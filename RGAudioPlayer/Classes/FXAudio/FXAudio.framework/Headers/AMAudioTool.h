//
//  AMAudioTool.h
//  7-20AudioPitch
//
//  Created by wyman on 2017/9/22.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMAudioTool : NSObject

/** 交错 left:@[1.0 ,2.0] right:@[3.0, 4.0] => output:@[1.0,3.0,2.0,4.0] */
+ (void)interleaveLeft:(float *)left right:(float *)right output:(float *)output numberOfSamples:(unsigned int)numberOfSamples;

/** 反交错 @[1.0,3.0,2.0,4.0] => left:@[1.0 ,2.0] right:@[3.0, 4.0]  */
+ (void)deInterleaveIutput:(float *)output left:(float *)left right:(float *)right numberOfSamples:(unsigned int)numberOfSamples;

@end
