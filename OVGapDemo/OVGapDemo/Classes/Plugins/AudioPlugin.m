//
//  AudioPlugin.m
//  OVGapDemo
//
//  Created by Vinson.D.Warm on 9/16/13.
//  Copyright (c) 2013 vepace. All rights reserved.
//

#import "AudioPlugin.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlugin () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation AudioPlugin

@synthesize audioPlayer = _audioPlayer;

- (void)testAudio:(OGInvokeCommand *)command {
    NSInteger currentState = 0;
    
    if (self.audioPlayer) {
        if ([self.audioPlayer isPlaying]) {
            [self.audioPlayer stop];
            currentState = 0;
        } else {
            if (self.audioPlayer.prepareToPlay) {
                [self.audioPlayer play];
                currentState = 1;
            } else {
                currentState = 0;
            }
        }
    }
    
    NSDictionary *resultInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:currentState] forKey:@"currentState"];
    [self toCallBackSuccess:resultInfo callBackId:command.callBackId];
}


// ****************************** lazy getter ******************************* //
- (AVAudioPlayer *)audioPlayer {
    if (!_audioPlayer) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"demo" ofType:@"mp3"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSDictionary *resultInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:0] forKey:@"currentState"];
    [self toTriggerListenerSuccess:resultInfo listenId:@"1001"];
}

@end
