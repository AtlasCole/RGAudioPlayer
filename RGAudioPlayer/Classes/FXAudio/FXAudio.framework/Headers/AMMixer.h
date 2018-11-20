//
//  AMMixer.h
//  FXAudio
//
//  Created by wyman on 2017/8/2.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMMixer : NSObject

/** outBuffer = volume*input + outBuffer volume控制input的强弱，0则没有声音，1则完全叠加  */
+ (void)mixInputBuffer:(float *)input outBuffer:(float *)output volume:(float)volume numberOfSamples:(int)numberOfSamples;

/** outBuffer = volume1*input1 + volume2*input2 volume控制input的强弱，0则没有声音，1则完全叠加  */
+ (void)mixInputBuffer1:(float *)input1 inputVolume1:(float)inputVolume1 inputBuffer2:(float *)input2 inputVolume2:(float)inputVolume2 outBuffer:(float *)output numberOfSamples:(int)numberOfSamples;


@end
