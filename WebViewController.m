//
//  WebViewController.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "ImageCache.h"
#import "ScaleImageViewController.h"

@interface WebViewController ()

@property (assign, nonatomic) BOOL loadingURL;
@property (assign, nonatomic) BOOL keyboardVisible;
@property (strong, nonatomic) ImageCache *imageCacher;
@property (strong, nonatomic) UIImage *selectedImage;
@end

@implementation WebViewController

@synthesize imageCacher, selectedImage;
@synthesize delegate;
@synthesize keyboardVisible;
@synthesize loadingURL;
@synthesize addressString;
@synthesize takePhotoButton;
@synthesize webView;
@synthesize addressField;
@synthesize toolBar;

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

    // Register the view for keyboard notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];
    
	// Do any additional setup after loading the view.
    self.imageCacher = [[ImageCache alloc] init];
    self.navigationController.navigationBar.backItem.title = @"Back";
    self.keyboardVisible = NO;
    
    self.loadingURL = NO;
    NSURL *url = [NSURL URLWithString:self.addressString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    self.addressField.text = self.addressString;
    [self.webView loadRequest:urlRequest];
}

- (void)viewDidUnload
{   
    //Remove the screen as an observer to keyboard notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self setWebView:nil];
    [self setAddressField:nil];
    [self setToolBar:nil];
    [self setTakePhotoButton:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    self.imageCacher = nil;
    self.selectedImage = nil;
    self.delegate = nil;
    self.addressString = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - IBAction Methods
- (IBAction)takePhoto:(UIBarButtonItem *)sender {
    NSString *imageName = self.webView.request.URL.lastPathComponent;
    NSString *imageURLString = self.webView.request.URL.absoluteString; 

    NSLog(@"USING IMAGE '%@'.", imageURLString);
    //Check to see if we are in a path that is a .jpg or a .png.
    if (![[imageName pathExtension] isEqualToString:@"jpg"] && ![[imageName pathExtension] isEqualToString:@"png"])
    {
        NSError *error;
        NSString *webData = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:imageURLString] encoding:NSUTF8StringEncoding error:&error];
        NSRange range = [webData rangeOfString:@"class=\"image\">"];
        webData = [webData substringFromIndex:range.location];
        range = [webData rangeOfString:@"src="];
        webData = [webData substringFromIndex:range.location + 5];
        range = [webData rangeOfString:@"\""];
        webData = [webData substringToIndex:range.location];
        range = [webData rangeOfString:@"http:"];
        if (range.length == 0)
        {
            imageURLString = [NSString stringWithFormat:@"http:%@", webData];
            imageName = [imageURLString lastPathComponent];
        }
        NSLog(@"Found URL: %@", webData);
    }
    
    // Return with the imageName & URL.
    NSLog(@"Taking image '%@' from '%@'.", imageName, imageURLString);
    [self.delegate webViewController:self didCaptureImageNamed:imageName fromURLString:imageURLString];
    [self.imageCacher cacheImageAtURL:imageURLString withName:imageName];
    
    self.selectedImage = [self.imageCacher getImageByName:imageName];
    if (self.selectedImage)
    {
        [self performSegueWithIdentifier:@"ScaleSegue" sender:self];
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ScaleSegue"])
    {
        ScaleImageViewController *scaleImageViewController = segue.destinationViewController;
        scaleImageViewController.image = self.selectedImage;
        scaleImageViewController.delegate = self;
    }
}

#pragma mark - UIWebViewControllerDelegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateActivityStatusWith:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView 
{
    [self updateActivityStatusWith:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateActivityStatusWith:NO];
}

- (void)updateActivityStatusWith:(BOOL)status
{
    self.loadingURL = status;
    self.takePhotoButton.enabled = !status;

    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = status;
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self updateViewForAddressFieldToShowKeyboard:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self updateViewForAddressFieldToShowKeyboard:NO];
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self updateViewForAddressFieldToShowKeyboard:NO];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self updateViewForAddressFieldToShowKeyboard:NO];
    [textField resignFirstResponder];
    return YES;
}

- (void)updateViewForAddressFieldToShowKeyboard:(BOOL)showKeyboard
{
//    if (showKeyboard){
//        //Show the keyboard and pan the toolbar up.        
//        CGPoint newCenter = CGPointMake(self.toolBar.center.x, 180);
//        NSLog(@"MOVING TOOLBAR CENTER: %f, %f", newCenter.x, newCenter.y);
//        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationCurveEaseIn 
//                         animations:^(void){
//                             self.toolBar.center = newCenter;
//                         }
//                         completion:^(BOOL done){
//                             self.keyboardVisible = YES;
//                         }];
//    }
//    else {
//        // Hide the keyboard and pan the toolbar down.
//        CGPoint newCenter = CGPointMake(self.toolBar.center.x, 394);
//        NSLog(@"MOVING TOOLBAR CENTER: %f, %f", newCenter.x, newCenter.y);
//        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationCurveEaseIn
//                         animations:^(void){
//                             self.toolBar.center = newCenter;
//                         }
//                         completion:^(BOOL done){
//                             self.keyboardVisible = NO;
//                         }];
//    }
}

- (void) liftMainViewWhenKeybordAppears:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

- (void) returnMainViewToInitialposition:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    [UIView commitAnimations];
}

#pragma mark - ScaleImageViewControllerDelegate Methods

- (void)scaleImageViewController:(ScaleImageViewController *)controller didCropImage:(UIImage *)image  
{
    // Delete the existing image, and save this image with the same name.
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scaleImageViewControllerDidCancel:(ScaleImageViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
