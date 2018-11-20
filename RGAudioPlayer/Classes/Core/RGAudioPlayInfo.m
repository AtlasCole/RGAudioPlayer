//
//  RGAudioPlayInfo.m
//  FXAudio_Example
//
//  Created by wzm on 2018/11/5.
//  Copyright © 2018 sherlockmm. All rights reserved.
//

#import "RGAudioPlayInfo.h"

@implementation RGAudioPlayInfo

- (void)setTimeNow:(NSString *)timeNow {
    _timeNow = timeNow;
    if (!timeNow) {
        _timeNow = @"00:00";
    }
}

- (void)setDuration:(NSString *)duration {
    _duration = duration;
    if (!duration) {
        _duration = @"00:00";
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    RGAudioPlayInfo *copyInfo  = [[RGAudioPlayInfo alloc] init];
    copyInfo.status = self.status;
    copyInfo.playeProgress = self.playeProgress;
    copyInfo.playTime = self.playTime;
    copyInfo.bufferTime = self.bufferTime;
    copyInfo.playDuration = self.playDuration;
    copyInfo.frequency = self.frequency;
    copyInfo.amplitude = self.amplitude;
    copyInfo.octave = self.octave;
    copyInfo.key = self.key;
    copyInfo.stepString = self.stepString;
    copyInfo.pitchStep = self.pitchStep;
    copyInfo.timeNow = self.timeNow;
    copyInfo.duration = self.duration;
    
    return copyInfo;
}

@end
