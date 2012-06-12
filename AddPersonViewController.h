//
//  AddPersonViewController.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@class AddPersonViewController;
@class Person;

@protocol AddPersonViewControllerDelegate <NSObject>

- (void)addPersonViewController:(AddPersonViewController *)controller didReturnWithPerson:(Person *)person;
- (void)addPersonViewControllerDidCancel:(AddPersonViewController *)controller;

@end

@interface AddPersonViewController : UIViewController<UITextFieldDelegate, WebViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id<AddPersonViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)cancelPressed:(UIBarButtonItem *)sender;
- (IBAction)donePressed:(UIBarButtonItem *)sender;
- (IBAction)imageViewPressed:(UIButton *)sender;

@end
