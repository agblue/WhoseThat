//
//  WebViewController.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScaleImageViewController.h"

@class WebViewController;

@protocol WebViewControllerDelegate <NSObject>

- (void)webViewController:(WebViewController *)controller didCaptureImageNamed:(NSString *)name fromURLString:(NSString *)urlString;

@end

@interface WebViewController : UIViewController<UITextFieldDelegate, UIWebViewDelegate, ScaleImageViewControllerDelegate>

@property (strong, nonatomic) id<WebViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *addressString;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *addressField;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)takePhoto:(UIBarButtonItem *)sender;

@end
