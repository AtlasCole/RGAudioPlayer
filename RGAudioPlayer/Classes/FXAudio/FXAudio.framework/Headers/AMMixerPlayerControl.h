//
//  AMMixerPlayerControl.h
//  FXAudio
//
//  Created by wyman on 2017/9/15.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioManager.h"

typedef NS_ENUM(NSUInteger, AMMixerPlayerEvent) {
    AMMixerPlayerEvent_LoadSuccess,
    AMMixerPlayerEvent_LoadError,
    AMMixerPlayerEvent_NetworkError,
    AMMixerPlayerEvent_EOF,
    AMMixerPlayerEvent_JogParameter,
    AMMixerPlayerEvent_DurationChanged,
    AMMixerPlayerEvent_LoopEnd,
};

@interface AMMixerPlayerControl : NSObject <AudioManagerDelegate>

+ (instancetype)controlWithHumanFileURL:(NSURL *)humanFileURL bgFileURL:(NSURL *)bgFileURL;

@property (nonatomic, strong) NSURL *humanFileURL;
@property (nonatomic, assign) float humanVolume;

@property (nonatomic, strong) NSURL *bgFileURL;
@property (nonatomic, assign) float bgVolume;

@property (nonatomic, assign) AMMixerPlayerEvent playerEvent;

#pragma mark - 控制
- (void)startPlayer;
- (void)resumePlayer;
- (void)pausePlayer;
- (void)stopPlayer;

/** 音频长度 s */
@property (nonatomic, assign) double duration;
/** 当前进度 0-1 */
@property (nonatomic, assign) float progress;
/** seek */
- (void)seekToProgress:(float)progress;
- (void)observeProgress:(void(^)(float progress))progressCallback;

@end
