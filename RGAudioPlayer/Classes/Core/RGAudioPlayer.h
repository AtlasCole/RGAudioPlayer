//
//  RGAudioPlayer.h
//  FXAudio_Example
//
//  Created by wzm on 2018/11/5.
//  Copyright © 2018 sherlockmm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGAudioPlayerProtocol.h"
#import "RGAudioPlayInfo.h"


NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nonnull const RGAudioPlayerBeginPlayNotification;
extern NSString * _Nonnull const RGAudioPlayerStopPlayNotification;

@interface RGAudioPlayer : NSObject <RGAudioPlayerProtocol>

@end

NS_ASSUME_NONNULL_END
