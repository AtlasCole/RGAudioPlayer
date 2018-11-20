//
//  RgAudioPlayerProtocol.h
//  FXAudio_Example
//
//  Created by wzm on 2018/11/5.
//  Copyright © 2018 sherlockmm. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 音频播放协议
 */
NS_ASSUME_NONNULL_BEGIN

/**
 音频播放器的播放状态
 */
typedef NS_ENUM(NSUInteger, RGAudioPlayStatus) {
    RGAudioPlayStatusUnknown     = 0 ,  // 未知状态
    RGAudioPlayStatusPlaying     = 1 ,  // 播放状态
    RGAudioPlayStatusPaused      = 2 ,  // 暂停状态
    RGAudioPlayStatusFailed      = 3 ,  // 失败状态
    RGAudioPlayStatusStopped     = 4 ,  // 停止状态
    RGAudioPlayStatusLoadSuccess = 5 ,  // 加载成功
    RGAudioPlayStatusPlayEnd     = 6 ,  // 播放结束
};

@class RGAudioPlayInfo;
@protocol RGAudioPlayerProtocol;

typedef void(^RGAudioPlayerInfoCallBack)(id<RGAudioPlayerProtocol> audioPlayer, RGAudioPlayInfo * playInfo);

@protocol RGAudioPlayerProtocol <NSObject>

@required
/* 当前播放状态 */
@property (nonatomic, assign, readonly) RGAudioPlayStatus playStatus;
/* 播放信息 */
@property (nonatomic, strong, readonly) RGAudioPlayInfo *playInfo;
/* 当前播放的URL */
@property (nonatomic, strong, readonly) NSURL *playingURL;
/* 是否正在播放 */
@property (nonatomic, assign, readonly) BOOL isPlaying;
/* 音量 */
@property (nonatomic, assign) float volume;
/* 静音 */
@property (nonatomic, assign) BOOL muted;

#pragma mark - 初始化
+ (instancetype)playerWithURL:(NSURL *)URL;

#pragma mark - 控制操作
- (void)startPlayWithURL:(NSURL *)URL;
- (void)play;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)seekToProgress:(float)progress;

#pragma mark - 监听
/**
 添加播放信息回调
 */
- (void)addObserver:(NSObject *)observer playInfoCallBack:(RGAudioPlayerInfoCallBack)playInfoCallback;

/**
 移除监听
 */
- (void)removeObserver:(NSObject *)observer;

@end

NS_ASSUME_NONNULL_END
