//
//  PaperImageViewController.m
//  DemoBlur
//
//  Created by hunk on 2/19/14.
//  Copyright (c) 2014 mx.blend. All rights reserved.
//

#import "PaperImageViewController.h"

@interface PaperImageViewController (){
	
	UIImage *image;
	UIImageView *imageV;
}

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation PaperImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)outputRotationData:(CMRotationRate)rotation
{
	
//	NSLog(@"pitch:%f",attitude.yaw);
	
	
//	NSLog(@"y:%f",rotation.y);
//	NSLog(@"z:%f",rotation.z);
	return;
	if (fabs(rotation.y) < .1) {
		return;
	}
	
	NSLog(@"valor :%f",rotation.y);
	if (rotation.y <= 0.0) {
		//la hizo a la derecha
		[self.uiscroll setContentOffset:CGPointMake( (imageV.frame.size.width-320), 0) animated:YES];
	}else{
		//izquierda
		[self.uiscroll setContentOffset:CGPointMake( 0, 0) animated:YES];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	
	image = [UIImage imageNamed:@"halladay.jpg"];

	
	CGFloat width = (self.view.frame.size.height / image.size.height) * image.size.width;
	
//	NSLog(@"%f",width);
//	NSLog(@"%f",image.size.height * image.size.width);
	CGRect frame = CGRectMake(0, 0, width, self.view.frame.size.height);
//	frame = CGRectMake(0, 0, 568, 568);
	//necesitamos saber el height de la pantalla
	
	
	imageV = [[UIImageView alloc] initWithFrame:frame];
	imageV.image = image;
//	imageV.contentMode = UIViewContentModeScaleAspectFit;
	
	[self.uiscroll addSubview:imageV];
	[self.uiscroll setContentSize:CGSizeMake(imageV.frame.size.width, /*image.size.height*/ self.uiscroll.bounds.size.height)];
	
	self.motionManager = [[CMMotionManager alloc] init];
//    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = 1 / 100;
	
	
	CGFloat step = (image.size.width / self.view.frame.size.width);
	
	NSInteger limitTop = self.uiscroll.contentSize.width - self.uiscroll.frame.size.width;
	
//	NSLog(@"contentsize %f",self.uiscroll.contentSize.width);
//	NSLog(@"tamaño %f",self.uiscroll.frame.size.width);
//	NSLog(@"diff %li",(long)maximoOffset);
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        //[self outputRotationData:gyroData.rotationRate];
										CGFloat speedRotationY = gyroData.rotationRate.y;
                                        if (fabs(speedRotationY) >= 0.1) {
											
                                            CGFloat moveX = self.uiscroll.contentOffset.x - speedRotationY * step;
											
                                            if (moveX > limitTop) {
                                                moveX = limitTop;
                                            } else if (moveX < 0) {
                                                moveX = 0;
                                            }
                                            [UIView animateWithDuration:0.3f
                                                                  delay:0.0f
                                                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                             animations:^{
                                                                 [self.uiscroll setContentOffset:CGPointMake(moveX, 0) animated:NO];
															 }
                                                             completion:nil];
                                        }
										
                                    }];
	
	
}

- (void)viewDidAppear:(BOOL)animated{

	[super viewDidAppear:animated];
	
//	NSLog(@"-- %@",NSStringFromCGSize(imageV.frame.size));
//	[self.uiscroll setContentOffset:CGPointMake( (imageV.frame.size.width-320)/2, 0) animated:YES];
	//no movemos a la mitad de la imagen
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
