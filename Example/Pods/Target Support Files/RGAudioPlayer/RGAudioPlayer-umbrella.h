#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RGAudioPlayer.h"
#import "RGAudioPlayerProtocol.h"
#import "RGAudioPlayInfo.h"

FOUNDATION_EXPORT double RGAudioPlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char RGAudioPlayerVersionString[];

