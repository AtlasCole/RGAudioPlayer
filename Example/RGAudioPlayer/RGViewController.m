//
//  RGViewController.m
//  RGAudioPlayer
//
//  Created by sherlockmm on 11/20/2018.
//  Copyright (c) 2018 sherlockmm. All rights reserved.
//

#import "RGViewController.h"
#import <RGAudioPlayer/RGAudioPlayer.h>

@interface RGViewController ()
@property (nonatomic, strong) RGAudioPlayer *player;
@end

@implementation RGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBegin:) name:RGAudioPlayerBeginPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay:) name:RGAudioPlayerStopPlayNotification object:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.player = [[RGAudioPlayer alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test2.mp3" ofType:nil];
    [self.player startPlayWithURL:[NSURL fileURLWithPath:path]];
    [self.player addObserver:self playInfoCallBack:^(id<RGAudioPlayerProtocol>  _Nonnull audioPlayer, RGAudioPlayInfo * _Nonnull playInfo) {
        NSLog(@"%@", playInfo.timeNow);
        NSLog(@"%@", playInfo.duration);
    }];
    
}

- (void)playBegin:(NSNotification *)nof
{
    NSLog(@"play");
}

- (void)stopPlay:(NSNotification *)nof
{
    NSLog(@"stop");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
