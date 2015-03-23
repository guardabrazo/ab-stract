//
//  SoundEffectPlayer.h
//  iChiquito
//
//  Created by Federico Guardabrazo Vallejo on 09/07/14.
//  Copyright (c) 2014 guardabrazo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SoundEffectPlayer;

@protocol SoundEffectDelegate <NSObject>

@optional
-(void)soundEffectDidFinishedPlaying:(SoundEffectPlayer*)soundEffectPlayer;

@end

@interface SoundEffectPlayer : NSObject 

@property (weak, nonatomic) id<SoundEffectDelegate> delegate;

@property (assign, nonatomic) int numberOfLoops;

-(void)play:(NSString*)fileName;
-(void)stop;

@end
