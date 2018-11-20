//
//  AMAudioPlayer.h
//  FXAudioDemo
//
//  Created by wyman on 2017/6/19.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMConst.h"

typedef enum AMAudioPlayerEvent {
    AMAudioPlayerEvent_LoadSuccess,
    AMAudioPlayerEvent_LoadError,
    AMAudioPlayerEvent_NetworkError,
    AMAudioPlayerEvent_EOF,
    AMAudioPlayerEvent_JogParameter,
    AMAudioPlayerEvent_DurationChanged,
    AMAudioPlayerEvent_LoopEnd,
} AMAudioPlayerEvent;

@class AMAudioPlayer;
@protocol AMAudioPlayerDelegate <NSObject>

@optional
- (void)audioPlayer:(AMAudioPlayer *)player playerEvent:(AMAudioPlayerEvent)event;

@end

@interface AMAudioPlayer : NSObject

@property (nonatomic, weak) id<AMAudioPlayerDelegate> delegate;

#pragma mark - 属性
/** 重设URL，URL合法后会停止播放，需要重新start */
@property (nonatomic, strong) NSURL *fileURL;
/** 是否暂停 */
@property (nonatomic, assign, readonly) BOOL paused;

/** 音频长度 s */
@property (nonatomic, assign) double duration;
/** 当前进度 0-1 */
@property (nonatomic, assign) float progress;
/** seek */
- (void)seekToProgress:(float)progress;
- (void)observeProgress:(void(^)(float progress))progressCallback;

#pragma mark - 初始化
- (instancetype)initWithFileURL:(NSURL *)url;

#pragma mark - 控制

/** 读取交错双声道 numberOfSamples采样数的buffer，返回值为是否读取有数据：YES==有数据 */
- (BOOL)playWithBuffers:(float *)buffers numberOfSamples:(int)numberOfSamples;

- (void)resume;

- (void)pause;

- (void)start;

- (void)stop;

@end
