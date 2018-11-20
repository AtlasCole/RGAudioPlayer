//
//  RGAudioPlayInfo.h
//  FXAudio_Example
//
//  Created by wzm on 2018/11/5.
//  Copyright © 2018 sherlockmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGAudioPlayerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 音高
 */
typedef NS_ENUM(NSUInteger, AudioPitchStep) {
    AudioPitchStepUndefined    = 0,
    AudioPitchStepC            = 1,
    AudioPitchStepD            = 2,
    AudioPitchStepE            = 3,
    AudioPitchStepF            = 4,
    AudioPitchStepG            = 5,
    AudioPitchStepA            = 6,
    AudioPitchStepB            = 7
};

@interface RGAudioPlayInfo : NSObject<NSCopying>

//---------------------------------base-------------------------------------------//
/** 播放状态 */
@property (nonatomic, assign) RGAudioPlayStatus status;

/** 当前播放进度 */
@property (nonatomic, assign) float playeProgress;

/** 当前播放时间(秒) */
@property (nonatomic, assign) float playTime;

/** 当前缓冲进度(秒) */
@property (nonatomic, assign) float bufferTime;

/** 总时长(秒) */
@property (nonatomic, assign) float playDuration;



//-----------------------------播放的音频信息-------------------------------------//
/** 频率 */
@property (nonatomic, assign) double frequency;
/** 能量 */
@property (nonatomic, assign) double amplitude;
/** 八度音阶 */
@property (nonatomic, assign) long octave;
/** 音高关系 */
@property (nonatomic, assign) long key;
/** 音高符号 */
@property (nonatomic, copy) NSString *stepString;
/** 音高 */
@property (nonatomic, assign) AudioPitchStep pitchStep;


//--------------------------- 处理后的时间信息 ------------------------------------//
/** 当前播放时间(00:00) */
@property (nonatomic, copy) NSString * _Nullable timeNow;

/** 总时长(00:00) */
@property (nonatomic, copy) NSString * _Nullable duration;

@end

NS_ASSUME_NONNULL_END
