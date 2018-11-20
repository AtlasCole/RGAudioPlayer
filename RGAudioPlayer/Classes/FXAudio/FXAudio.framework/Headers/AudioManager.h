//
//  AudioManager.h
//  6-16Recorder-Effect
//
//  Created by wyman on 2017/6/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FXAudio/FXItem.h"

typedef id (^WeakReference)(void);

@class AudioManager;
@protocol AudioManagerDelegate <NSObject>

@optional

//
// 音频IO线程回调，buffers为交错双声道float格式，返回值代表喇叭是否静音，YES则代表静音，NO代表有非静音
//

/** 前处理器，处理前回调 */
- (BOOL)audioManagerIOBeforePreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 前处理器，处理后回调 */
- (BOOL)audioManagerIOAfterPreFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 处理器，处理前回调 */
- (BOOL)audioManagerIOBeforeFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

/** 处理器，处理后回调 */
- (BOOL)audioManagerIOAfterFX:(AudioManager *)manager buffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

@end

typedef NS_ENUM(NSUInteger, AMNsLevel) {
    AMNsLevelLow,
    AMNsLevelModerate,
    AMNsLevelHigh,
    AMNsLevelVeryHigh
};

@interface AudioManager : NSObject

@property (nonatomic, weak) id<AudioManagerDelegate> delegate;

@property (nonatomic, assign, getter=isOpenIO, readonly) BOOL openIO;

@property (nonatomic, assign) BOOL openPreFX;
@property (nonatomic, assign) BOOL openFX;

#pragma mark - 增加回调target【在触发delegate之后】不能触发IO静音逻辑，实现协议后的返回值无效
- (void)addTarget:(id<AudioManagerDelegate>)target;
- (void)removeTarget:(id<AudioManagerDelegate>)target;

#pragma mark - 构造
- (instancetype)initWithDelegate:(id<AudioManagerDelegate>)delegate;

#pragma mark - IO开关
- (void)openAudioIO;

- (void)closeAudioIO;

#pragma mark - preFX控制
- (void)setAgcState:(bool)enable;    // 默认关闭
- (void)setNsState:(bool)enable;     // 默认开启
- (void)setNsLevel:(AMNsLevel)level; // 默认 AMNsLevelModerate

#pragma mark - FX控制
@property (nonatomic, strong) NSMutableArray<FXItem *> *fxArrayM;



@end
