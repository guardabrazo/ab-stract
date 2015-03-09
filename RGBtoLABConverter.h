//
//  RGBtoLABConverter.h
//  ab·stract
//
//  Created by guardabrazo on 9/3/15.
//  Copyright (c) 2015 Espadaysantacruz Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RGBtoLABConverter : NSObject

@property (strong, nonatomic) NSNumber *L;
@property (strong, nonatomic) NSNumber *A;
@property (strong, nonatomic) NSNumber *B;

- (instancetype)initWithRed: (int)red
                      green: (int)green
                       blue: (int)blue;


@end
