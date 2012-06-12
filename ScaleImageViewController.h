//
//  ScaleImageViewController.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScaleImageViewController;

@protocol ScaleImageViewControllerDelegate <NSObject>

- (void)scaleImageViewControllerDidCancel:(ScaleImageViewController *)controller;
- (void)scaleImageViewController:(ScaleImageViewController *)controller didCropImage:(UIImage *)image;

@end

@interface ScaleImageViewController : UIViewController<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) id<ScaleImageViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *image;

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;
- (IBAction)handleRotate:(UIRotationGestureRecognizer *)sender;

- (IBAction)cancelPressed:(UIBarButtonItem *)sender;
- (IBAction)cropPressed:(UIBarButtonItem *)sender;

@end
