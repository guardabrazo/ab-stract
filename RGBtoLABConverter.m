//
//  RGBtoLABConverter.m
//  ab·stract
//
//  Created by guardabrazo on 9/3/15.
//  Copyright (c) 2015 Espadaysantacruz Studio. All rights reserved.
//

#import "RGBtoLABConverter.h"

@interface RGBtoLABConverter()

@property (assign, nonatomic) float red;
@property (assign, nonatomic) float green;
@property (assign, nonatomic) float blue;

@property (assign, nonatomic) float X;
@property (assign, nonatomic) float Y;
@property (assign, nonatomic) float Z;

@end


@implementation RGBtoLABConverter

-(instancetype)initWithRed:(int)red green:(int)green blue:(int)blue{
    
    self = [super init];
    if (self) {
        _red = red;
        _green = green;
        _blue = blue;
        [self fromRGBtoXYZ];
        [self fromXYZtoLAB];
        
    }
    return self;
}


- (void)fromRGBtoXYZ{
    float R = (self.red / 255);
    float G = (self.green / 255);
    float B = (self.blue / 255);
    
    if( R > 0.04045 ){
        R = pow((R + 0.055)/1.055, 2.4);
        
    }else{
        R = R / 12.92;
    }
    
    if( G > 0.04045 ){
        G = pow((G + 0.055)/1.055, 2.4);
        
    }else{
        G = G / 12.92;
    }
    
    if( B > 0.04045 ){
        B = pow((B + 0.055)/1.055, 2.4);
    }else{
        B = B / 12.92;
    }
    
    R = R * 100;
    G = G * 100;
    B = B * 100;
    
    self.X = R * 0.4124 + G * 0.3576 + B * 0.1805;
    self.Y = R * 0.2126 + G * 0.7152 + B * 0.0722;
    self.Z = R * 0.0193 + G * 0.1192 + B * 0.9505;
}


- (void)fromXYZtoLAB{
    
    float X = self.X / 100.00;
    float Y = self.Y / 100.00;
    float Z = self.Z / 100.00;
    
    if ( X > 0.008856 ){
        X = pow(X, 1/3.00);
    }else{
        X = ( 7.787 * X ) + ( 16 / 116 );
    }
    
    if ( Y > 0.008856 ){
        Y = pow(Y, 1/3.00);
    }else{
        Y = ( 7.787 * Y ) + ( 16 / 116 );
    }
    if ( Z > 0.008856 ){
        Z = pow(Z, 1/3.00);
    }else{
        Z = ( 7.787 * Z ) + ( 16 / 116 );
    }
    
    self.L = [NSNumber numberWithFloat:( 116 * Y ) - 16];
    self.A = [NSNumber numberWithFloat:500 * ( X - Y )];
    self.B = [NSNumber numberWithFloat:200 * ( Y - Z )];
}

@end
