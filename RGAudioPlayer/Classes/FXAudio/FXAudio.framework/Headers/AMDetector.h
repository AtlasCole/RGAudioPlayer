//
//  AMDetector.h
//  FXAudio
//
//  Created by wyman on 2017/9/22.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AMPitchStep) {
    AMPitchStepUndefined    = 0,
    AMPitchStepC            = 1,
    AMPitchStepD            = 2,
    AMPitchStepE            = 3,
    AMPitchStepF            = 4,
    AMPitchStepG            = 5,
    AMPitchStepA            = 6,
    AMPitchStepB            = 7
};

@interface AMPitch : NSObject

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
@property (nonatomic, assign) AMPitchStep pitchStep;

@end

@interface AMDetector : NSObject

/** 初始化检测器 */
- (instancetype)initWithNumberOfSamples:(unsigned int)numberOfSamples sampleRate:(double)sampleRate;

/** 检测 input为单声道buffer */
- (AMPitch *)detectBuffer:(float *)input numberOfSamples:(unsigned int)numberOfSamples;
/** 检测 input为交错双声道buffer 检测左声道 */
- (AMPitch *)detectInterleaveBuffer:(float *)input numberOfSamples:(unsigned int)numberOfSamples;


@end
