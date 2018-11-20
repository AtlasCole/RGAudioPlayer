//
//  RGAudioPlayer.m
//  FXAudio_Example
//
//  Created by wzm on 2018/11/5.
//  Copyright © 2018 sherlockmm. All rights reserved.
//

#import "RGAudioPlayer.h"
#import <FXAudio/FXAudio.h>

NSString * _Nonnull const RGAudioPlayerBeginPlayNotification = @"RGAudioPlayerBeginPlayNotification";
NSString * _Nonnull const RGAudioPlayerStopPlayNotification  = @"RGAudioPlayerStopPlayNotification";

typedef id (^RGWeakReference)(void);

// 希望获取的WYAVMakeWeakReference与obj意义对应可以充当key
// 但是这样做在 __weak id weakref = object;此处可能因为object在dealloc方法调用而无法weak修饰导致crash，暂时注释
// 由于获取object 地址 误使用&object 导致key不唯一
static NSMutableDictionary *g_weakReferenceKeyMap;
static RGWeakReference getKeyWithObj(id object) {
    if (!g_weakReferenceKeyMap) {
        g_weakReferenceKeyMap = [NSMutableDictionary dictionary];
    }
    RGWeakReference keyReference = [g_weakReferenceKeyMap objectForKey:[NSString stringWithFormat:@"%p", object]];
    if (!keyReference) {
        __weak id weakref = object;
        keyReference = ^{
            return weakref;
        };
        [g_weakReferenceKeyMap setObject:keyReference forKey:[NSString stringWithFormat:@"%p", object]];
    }
    return keyReference;
}
// 装包
static RGWeakReference RGAudioPlayerMakeWeakReference(id object) {
    return getKeyWithObj(object);
}
// 解包
static id RGAudioPlayerPlayWeakReferenceNonretainedObjectValue(RGWeakReference ref) {
    return ref ? ref() : nil;
}


@interface RGAudioDetector : AMDetector

/*
 人耳只能听到22.0HZ 抽样定理 44100HZ 人耳最敏感的范围
 采样精度 16bit 32bit
 PCM:
 LR LR LR LR LR LR LR // 左右声道
 采样率为44100 1秒钟采样44100
 采样数据 由离散的点来构成 ->最终形成音频波形
 */

/**
 return current instance
 */
+ (instancetype)sharedDetector;

@end


@implementation RGAudioDetector

/**
 return current instance
 */
static RGAudioDetector *instance = nil;
+ (instancetype)sharedDetector
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RGAudioDetector alloc] initWithNumberOfSamples:BUFFER_SAMPLE_COUNT sampleRate:FS];
    });
    return instance;
}

@end

/* 播放状态 */
#define k_PLAYEREVENT_KEY_PATH @"playerEvent"

@interface RGAudioPlayer ()<AudioManagerDelegate>
/* 音频控制器 */
@property (nonatomic, strong) AMMixerPlayerControl *audioControl;
/* 音频IO管理 */
@property (nonatomic, strong) AudioManager *audioManager;
/* 音频检测 */
@property (nonatomic, strong) RGAudioDetector *audioDetector;

/* currentURL */
@property (nonatomic, strong) NSURL *currentURL;
/* 播放信息 */
@property (nonatomic, strong) RGAudioPlayInfo *audioPlayInfo;

/* isPlaying */
@property (nonatomic, assign) BOOL isPlaying;
/* RgAudioPlayStatus */
@property (nonatomic, assign) RGAudioPlayStatus stauts;
/** 回调定时器 */
@property (nonatomic, weak) NSTimer *timer;

/* observerMap */
@property (nonatomic, strong) NSMutableDictionary<RGWeakReference, RGAudioPlayerInfoCallBack> *observerMap;
/* kvoMap */
@property (nonatomic, strong) NSMutableDictionary<NSString * , NSString*> *kvoMap;
@end

@implementation RGAudioPlayer

#pragma RgAudioPlayerProtocol

+ (instancetype)playerWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    if (self = [super init]) {
        //---------------------------------------------//
        self.currentURL = URL;
        self.isPlaying = NO;
    }
    return self;
}

- (void)updateTimer
{
    NSMutableArray<RGWeakReference> *deleteTargetList = [NSMutableArray array];
    [self.observerMap enumerateKeysAndObjectsUsingBlock:
     ^(RGWeakReference  _Nonnull key, RGAudioPlayerInfoCallBack  _Nonnull obj, BOOL * _Nonnull stop) {
        NSObject *target = RGAudioPlayerPlayWeakReferenceNonretainedObjectValue(key);
        if (!target) {
            [deleteTargetList addObject:key];
        } else {
            if (obj) {
                obj(self, self.playInfo);
            }
        }
    }];
    [self.observerMap removeObjectsForKeys:deleteTargetList];
}

#pragma mark - 控制操作
- (void)startPlayWithURL:(NSURL *)URL
{
    if (self.audioControl && self.isPlaying) {
        if ([URL isEqual:self.currentURL]) {
            [self  resume];
            return;
        }else {
            [self stop];
        }
    }
    _currentURL = URL;
    self.isPlaying = NO;
    [self play];
}

- (void)play
{
    [self.audioManager openAudioIO];
    self.audioControl.bgFileURL = self.currentURL;
    [self.audioControl startPlayer];
    self.audioPlayInfo = [[RGAudioPlayInfo alloc] init];
    [self addObserverAudioPlayInformation];
    [self updateTimer];
    [self scheduledTimer];
    self.stauts = RGAudioPlayStatusPlaying;
    self.isPlaying = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:RGAudioPlayerBeginPlayNotification object:self];
}

- (void)stop
{
    [self.audioControl stopPlayer];
    [self.audioManager closeAudioIO];
    self.stauts = RGAudioPlayStatusStopped;
    self.isPlaying = NO;
    self.audioPlayInfo = nil;
    [self invalidTimer];
    [self removeKeyPathObserver];
    [[NSNotificationCenter defaultCenter] postNotificationName:RGAudioPlayerStopPlayNotification object:self];
}

- (void)pause
{
    if ([self.audioManager isOpenIO]) {
        [self.audioControl pausePlayer];
        self.stauts = RGAudioPlayStatusPaused;
        self.isPlaying = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:RGAudioPlayerStopPlayNotification object:self];
    }
}

- (void)resume
{
    if ([self.audioManager isOpenIO]) {
        [self.audioControl resumePlayer];
        self.stauts = RGAudioPlayStatusPlaying;
        self.isPlaying = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:RGAudioPlayerBeginPlayNotification object:self];
    }
}

- (void)seekToProgress:(float)progress
{
    [self.audioControl seekToProgress:progress];
    self.audioPlayInfo.playeProgress = progress;
}

#pragma mark - 信息回调
- (void)scheduledTimer {
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

- (void)invalidTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 监听
static void *PlayStatus_KVO = &PlayStatus_KVO;
- (void)addObserverAudioPlayInformation
{
    // 回调的当前的时间
    __weak typeof(self) weakSelf = self;
     RGAudioPlayInfo *playInfo = [[RGAudioPlayInfo alloc] init];
    [self.audioControl observeProgress:^(float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) self = weakSelf;
            if (self == nil) return;
            playInfo.timeNow = [self timeStringWithFloat:self.audioControl.duration*progress];
            playInfo.duration = [self timeStringWithFloat:self.audioControl.duration];
            playInfo.playeProgress = progress;
            playInfo.status = RGAudioPlayStatusPlaying;
            self.audioPlayInfo = playInfo;
        });
    }];
    
    // 播放状态的改变
    [self.audioControl addObserver:self forKeyPath:k_PLAYEREVENT_KEY_PATH options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:PlayStatus_KVO];
}

- (void)addObserver:(NSObject *)observer playInfoCallBack:(RGAudioPlayerInfoCallBack)playInfoCallback
{
    if (playInfoCallback) {
        [self.observerMap setObject:playInfoCallback forKey:RGAudioPlayerMakeWeakReference(observer)];
    }
}

- (void)removeObserver:(NSObject *)observer
{
    RGWeakReference key = RGAudioPlayerMakeWeakReference(observer);
    if ([self.observerMap.allKeys containsObject:key]) {
        [self.observerMap removeObjectForKey:key];
    }
}

- (void)removeKeyPathObserver
{
    [self.audioControl removeObserver:self forKeyPath:k_PLAYEREVENT_KEY_PATH];
}

#pragma mark - AudioManagerDelegate

/** 前处理器，处理前回调 */
- (BOOL)audioManagerIOBeforePreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples
{
    if (self.playStatus == RGAudioPlayStatusPlaying) {
        AMPitch *pitch = [self.audioDetector detectInterleaveBuffer:buffers numberOfSamples:numberOfSamples];
        RGAudioPlayInfo *playInfo = [self.playInfo copy];
        playInfo.frequency = pitch.frequency;
        playInfo.amplitude = pitch.amplitude;
        playInfo.stepString = pitch.stepString;
        playInfo.octave = pitch.octave;
        playInfo.key = pitch.key;
        playInfo.pitchStep = (AudioPitchStep)pitch.pitchStep;
        self.audioPlayInfo = playInfo;
    }
    return NO;
}

#pragma mark - KVO

/**
 Value Change
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSString *kvoHashKey = [self hashKeyContext:context withKeyPath:keyPath];
    SEL sel = NSSelectorFromString([self.kvoMap objectForKey:kvoHashKey]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:sel withObject:change];
#pragma clang diagnostic pop
}

/**
 播放状态改变
 */
- (void)playerControlEventChange:(NSDictionary<NSKeyValueChangeKey,id> *)change
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AMMixerPlayerEvent playerEvent = [change[NSKeyValueChangeNewKey] integerValue];
        if (playerEvent == AMMixerPlayerEvent_LoadSuccess) { // 加载成功
            self.stauts = RGAudioPlayStatusLoadSuccess;
        }else if (playerEvent == (AMMixerPlayerEvent_LoadError)) {
            self.stauts = RGAudioPlayStatusFailed;
        }else if (playerEvent == AMMixerPlayerEvent_EOF){
            self.stauts = RGAudioPlayStatusPlayEnd;
        }
    });
}

- (NSString *)hashKeyContext:(void *)context withKeyPath:(NSString *)keyPath {
    NSString *contextAddress = [NSString stringWithFormat:@"%p", context];
    NSString *hashKey = [keyPath stringByAppendingString:contextAddress];
    return hashKey;
}

#pragma mark setter/getter

//----------------init AMMixerPlayerControl ----------------------//
- (AMMixerPlayerControl *)audioControl
{
    if (!_audioControl) {
        _audioControl = [AMMixerPlayerControl controlWithHumanFileURL:nil bgFileURL:nil];
    }
    return _audioControl;
}

- (AudioManager *)audioManager
{
    if (!_audioManager) {
        _audioManager = [[AudioManager alloc] initWithDelegate:self.audioControl];
        [_audioManager addTarget:self];
    }
    return _audioManager;
}

- (RGAudioDetector *)audioDetector
{
    if (!_audioDetector) {
        _audioDetector = [RGAudioDetector sharedDetector];
    }
    return _audioDetector;
}

- (NSMutableDictionary<RGWeakReference,RGAudioPlayerInfoCallBack> *)observerMap
{
    if (!_observerMap) {
        _observerMap = [NSMutableDictionary dictionary];
    }
    return _observerMap;
}

- (NSMutableDictionary<NSString *,NSString *> *)kvoMap
{
    if (!_kvoMap) {
        _kvoMap = [NSMutableDictionary dictionary];
        // playerControlEventChange
        [_kvoMap setObject:NSStringFromSelector(@selector(playerControlEventChange:)) forKey:[self hashKeyContext:PlayStatus_KVO withKeyPath:k_PLAYEREVENT_KEY_PATH]];
    }
    return _kvoMap;
}

- (RGAudioPlayStatus)playStatus
{
    return _stauts;
}

- (NSURL *)playingURL
{
    return _currentURL;
}

- (void)setMuted:(BOOL)muted
{
    float volume = muted ? 0.0f:self.audioControl.bgVolume;
    [self.audioControl setBgVolume:volume];
}

- (BOOL)muted
{
    return (self.audioControl.bgVolume == 0.0f);
}

- (void)setVolume:(float)volume
{
    [self.audioControl setBgVolume:volume];
}

- (float)volume
{
    return self.audioControl.bgVolume;
}

- (RGAudioPlayInfo *)playInfo
{
    return self.audioPlayInfo;
}

- (BOOL)isIsPlaying
{
    return self.isPlaying;
}

- (void)setStauts:(RGAudioPlayStatus)stauts
{
    _stauts = stauts;
    RGAudioPlayStatus oldPlayStatus = self.audioPlayInfo.status;
    self.audioPlayInfo.status = _stauts;
    if (oldPlayStatus != stauts) {
        [self updateTimer];
    }
}

#pragma mark -tools
- (NSString *)timeStringWithFloat:(CGFloat)time {
    int timeInt = (int)time;
    int seconds = timeInt % 60;
    int minutes = (timeInt / 60) % 60;
    int hours = timeInt / 3600;
    if (timeInt < 3600) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
}
@end
