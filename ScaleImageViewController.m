//
//  ScaleImageViewController.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScaleImageViewController.h"

@interface ScaleImageViewController ()

@end

@implementation ScaleImageViewController
@synthesize delegate;
@synthesize imageView;
@synthesize image;

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
    self.imageView.image = image;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.image = nil;
    self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;   
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x, 
                                         sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)sender {
    sender.view.transform = CGAffineTransformRotate(sender.view.transform, sender.rotation);
    sender.rotation = 0;
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.delegate scaleImageViewControllerDidCancel:self];
}

- (IBAction)cropPressed:(UIBarButtonItem *)sender {
    [self.delegate scaleImageViewControllerDidCancel:self];
    //[self.delegate scaleImageViewController:self didCropImage:image];
}

#pragma mark - UIGestureRecognizerDelegate Methods
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {        
    return YES;
}



@end
