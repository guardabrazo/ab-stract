//
//  SoundEffectPlayer.m
//  iChiquito
//
//  Created by Federico Guardabrazo Vallejo on 09/07/14.
//  Copyright (c) 2014 guardabrazo. All rights reserved.
//

#import "SoundEffectPlayer.h"

@interface SoundEffectPlayer () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation SoundEffectPlayer

-(void)play:(NSString*)fileName{
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"]];
	NSError *error;
    
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    
    self.audioPlayer.numberOfLoops = self.numberOfLoops;
    self.audioPlayer.volume = self.volume;
    
    [self.audioPlayer play];
}

-(void)stop{
    
    [self.audioPlayer stop];
}

#pragma mark - AVAudioPlayerDelegate methods

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    if ([self.delegate respondsToSelector:@selector(soundEffectDidFinishedPlaying:)]) {
        [self.delegate soundEffectDidFinishedPlaying:self];
    }
}

@end
