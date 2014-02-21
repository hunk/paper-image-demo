//
//  MainViewController.m
//  DemoBlur
//
//  Created by hunk on 2/17/14.
//  Copyright (c) 2014 mx.blend. All rights reserved.
//

#import "MainViewController.h"
#import "UIImage+ImageEffects.h"

@interface MainViewController (){

	UIImageView *blurImage;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[self step1];
}

- (void)step1{
	
	UIImage *image = [UIImage imageNamed:@"phillies.jpg"];
	
	UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
	imageV.image = image;
	imageV.contentMode = UIViewContentModeScaleAspectFit;
	
	//	[self.view addSubview:imageV];
	
	//	NSData *originalData = UIImageJPEGRepresentation(image, 1.0);
	//	NSLog(@"1 Size of Image(bytes):%d",[originalData length]);
	
	//bajamos la calidad
	NSData *imageAsData = UIImageJPEGRepresentation(image, 0.001);
	
	//	NSLog(@"2 Size of Image(bytes):%d",[imageAsData length]);
	UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:self.view.bounds];
	
	imageV2.image = [UIImage imageWithData:imageAsData];
	imageV2.contentMode = UIViewContentModeScaleAspectFit;
	
	CGRect frame = imageV2.frame;
	//	frame.origin.y += 100;
	imageV2.frame = frame;
	
	[self.view addSubview:imageV2];
	
	blurImage = imageV2;
	
	
	[self performSelector:@selector(vamos) withObject:nil afterDelay:2.0];
}

- (void)vamos{
		
	UIImage *img = [blurImage.image applyBlurWithRadius:34 tintColor:[UIColor colorWithWhite:0 alpha:.3] saturationDeltaFactor:1.4 maskImage:nil];
	
	UIImageView *tmp = [[UIImageView alloc] initWithFrame:blurImage.frame];
	tmp.contentMode = UIViewContentModeScaleAspectFit;
	tmp.image = img;
	tmp.alpha = 0.0;
	
	[self.view insertSubview:tmp aboveSubview:blurImage];
//	[self.view addSubview:tmp];
	
	[UIView animateWithDuration:1.0 animations:^{
	
		[tmp setAlpha:1.0];
//		[blurImage setAlpha:0.0];
		
	} completion:^(BOOL finished) {
		
		blurImage.image = img;
		blurImage.alpha = 1.0;
		
		[tmp removeFromSuperview];
		
	}];
	
	/*
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	
    blurImage.image = img;
	
    [UIView commitAnimations];*/
	
}

- (IBAction)againAction:(id)sender {
	[self step1];
}
@end
