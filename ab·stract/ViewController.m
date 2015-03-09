//
//  ViewController.m
//  ab·stract
//
//  Created by guardabrazo on 5/3/15.
//  Copyright (c) 2015 Espadaysantacruz Studio. All rights reserved.
//

#import "ViewController.h"
#import "RGBtoLABConverter.h"

@interface ViewController ()

@property (assign, nonatomic) float red;
@property (assign, nonatomic) float green;
@property (assign, nonatomic) float blue;

@property (assign, nonatomic) CGFloat minScale;
@property (nonatomic, strong) UIImageView *imageView;

@property (strong, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) NSMutableArray *distancesArray;

@property (strong, nonatomic) UIView *colorView;

@property (strong, nonatomic) RGBtoLABConverter *converter;


- (void)centerScrollViewContents;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.view.userInteractionEnabled = NO;
    
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    self.minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = self.minScale;
    
    // 5
    self.scrollView.maximumZoomScale = 1200.0f;
    self.scrollView.zoomScale = self.minScale;
    
    // 6
    [self centerScrollViewContents];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
    
    self.imagesArray = [NSArray arrayWithContentsOfFile:path];
    
    int randomIndex = arc4random_uniform([self.imagesArray count]);
    
    NSString *imageName = self.imagesArray[randomIndex][0];
    
    UIImage *randomImage = [UIImage imageNamed:imageName];
    self.imageView = [[UIImageView alloc] initWithImage:randomImage];
    self.imageView.layer.magnificationFilter = kCAFilterNearest;
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=randomImage.size};
    NSLog(@"ImageView Frame = WIDTH %f, HEIGHT = %f", self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.imageView];
    
    // 2
    self.scrollView.contentSize = randomImage.size;
    NSLog(@"Content Size = WIDTH %f, HEIGHT = %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    
    
    
    /////////
    
    
    
    self.distancesArray = [[NSMutableArray alloc]init];
    
    NSLog(@"Array Length = %d", [self.imagesArray count]);
    
    self.red = 0;
    self.green = 0;
    self.blue = 0;
    
    
    self.colorView = [[UIView alloc]initWithFrame:self.view.frame];
    self.colorView.alpha = 0.0;
    [self.view addSubview:self.colorView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//SCROLLVIEW

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    if (scrollView.zoomScale > 1100) {
        NSLog(@"Do the magic!");
        [self getRGBPixelColor];
        self.view.userInteractionEnabled = NO;
        
        self.colorView.backgroundColor = [UIColor colorWithRed:self.red/255 green:self.green/255 blue:self.blue/255 alpha:1];
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.colorView.alpha = 1;
                         }completion:^(BOOL finished) {
                             [self resetImage];
                         }];
        
        
        
    }
    [self centerScrollViewContents];
}

-(void)resetImage{
    self.converter = [[RGBtoLABConverter alloc]initWithRed:self.red green:self.green blue:self.blue];
    
    [self checkDistance];
}

- (void)getRGBPixelColor
{
    
    UIGraphicsBeginImageContext(self.view.window.bounds.size);
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //self.imageView.image = image;
    //[self.imageView.layer setMagnificationFilter:kCAFilterNearest];
    
    //self.imageView.transform = CGAffineTransformMakeScale(1, 1);
    
    
    CGImageRef cgImage = image.CGImage;
    size_t width = self.view.frame.size.width;
    size_t height = self.view.frame.size.height;
    NSUInteger x = self.view.frame.size.width*0.5;
    NSUInteger y = self.view.frame.size.height*0.5;
    
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    if ((x < width) && (y < height)){
        
        CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
        CFDataRef bitmapData = CGDataProviderCopyData(provider);
        const UInt8* data = CFDataGetBytePtr(bitmapData);
        size_t offset = ((width * y) + x) * 4;
        red =  data[offset];       //notice red and blue are swapped
        green = data[offset + 1];
        blue =   data[offset + 2];
        CFRelease(bitmapData);
        
        NSLog(@"X = %i, Y = %i, RED = %i   GREEN = %i   BLUE = %i", x, y, blue, green, red);
        self.red = blue;
        self.green = green;
        self.blue = red;
    }
    
}

- (void)showRandomImage{
    
    int randomIndex = arc4random_uniform([self.imagesArray count]);
    
    NSString *imageName = self.imagesArray[randomIndex][0];
    
    UIImage *randomImage = [UIImage imageNamed:imageName];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = randomImage;
    [self.view addSubview:imageView];
}

- (void)checkDistance{
    
    for (int i = 0; i < [self.imagesArray count]; i++) {
        NSNumber *L1 = self.imagesArray[i][1][0];
        NSNumber *A1 = self.imagesArray[i][1][1];
        NSNumber *B1 = self.imagesArray[i][1][2];
        
        float distanceL = powf([L1 floatValue]- [self.converter.L floatValue], 2);
        float distanceA = powf([A1 floatValue] - [self.converter.A floatValue], 2);
        float distanceB = powf([B1 floatValue] - [self.converter.B floatValue], 2);
        
        float distance = sqrtf(distanceL + distanceA + distanceB);
        [self.distancesArray addObject:[NSNumber numberWithFloat:distance]];
    }
    
    NSLog(@"There are %d distances in the array", [self.distancesArray count]);
    
    for (int i = 0; i < [self.distancesArray count]; i++) {
        NSLog(@"%d Distance = %@", i, self.distancesArray[i]);
    }
    
    
    __block NSUInteger minIndex;
    __block float xmin = MAXFLOAT;
    [self.distancesArray enumerateObjectsUsingBlock:^(NSNumber *num, NSUInteger idx, BOOL *stop) {
        float x = num.floatValue;
        if (x < xmin){
            xmin = x;
            minIndex = idx;
        }
        
        
    }];
    
    NSLog(@"MIN VALUE = %f", xmin);
    NSLog(@"MIN INDEX = %d", minIndex);
    
    [self displayImageWithIndex:minIndex];
    [self.distancesArray removeAllObjects];
    
    
}

- (void)displayImageWithIndex: (NSUInteger) index{
    
    NSString *imageName = self.imagesArray[index][0];
    
    UIImage *randomImage = [UIImage imageNamed:imageName];
    
    self.imageView.image = randomImage;
    self.scrollView.zoomScale = self.minScale;
    [UIView animateWithDuration:4
                     animations:^{
                         self.colorView.alpha = 0.0;
                     }completion:^(BOOL finished) {
                         self.view.userInteractionEnabled = YES;
                     }];
    
}

@end
