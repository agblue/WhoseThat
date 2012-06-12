//
//  AddPersonViewController.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddPersonViewController.h"
#import "WebViewController.h"
#import "Person.h"
#import "ImageCache.h"

@interface AddPersonViewController ()
{
    ImageCache *imageCacher;
}

@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *imageURLString;

@end

@implementation AddPersonViewController

@synthesize imgPicker;
@synthesize imageName, imageURLString;
@synthesize delegate;
@synthesize nameTextField;
@synthesize textView;
@synthesize doneButton;
@synthesize scrollView;

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
	// Do any additional setup after loading the view.
    
    //Setup Image Cacher.
    imageCacher = [[ImageCache alloc] init];
    
    //Disable the button if the length is 0.
    [self enableDoneButton];

    //Add Keyboard Notification for the screen.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidUnload
{    
    [self setNameTextField:nil];
    [self setDoneButton:nil];
    [self setTextView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    imageCacher = nil;
    self.imgPicker = nil;
    self.delegate = nil;
    self.imageName = nil;
    self.imageURLString = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GoogleSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        webViewController.addressString = @"http://www.google.com/";
        webViewController.title = @"Google";
    }
    else if ([segue.identifier isEqualToString:@"WikiSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        NSString *searchString = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        webViewController.addressString = [NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@", searchString];        
        webViewController.title = @"Wiki";
        webViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"TwitterSegue"])
    {
        WebViewController *webViewController = segue.destinationViewController;
        NSString *searchString = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        webViewController.addressString = [NSString stringWithFormat:@"http://twitter.com/#!/search/%@", searchString];        
        webViewController.title = @"Twitter";
        webViewController.delegate = self;
    }
}

#pragma mark - UITextFieldDelegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextField)
    {
        [self enableDoneButton];
    }
    [textField resignFirstResponder];    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)enableDoneButton
{
    if ([self.nameTextField.text length] == 0)
    {
        self.doneButton.enabled = NO;
    }
    else{
        self.doneButton.enabled = YES;
    }
}

#pragma mark - IBAction Methods

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self.delegate addPersonViewControllerDidCancel:self];
}

- (IBAction)donePressed:(UIBarButtonItem *)sender {
    Person *newPerson = [[Person alloc] init];
    newPerson.name = self.nameTextField.text;
    newPerson.notes = self.textView.text;
    
    if (self.imageName)
    {
        newPerson.imageName = self.imageName;
    }
    if (self.imageURLString)
    {
        newPerson.imageURLString = self.imageURLString;
        [imageCacher cacheImageAtURL:newPerson.imageURLString withName:newPerson.imageName];
    }
    [self.delegate addPersonViewController:self didReturnWithPerson:newPerson];
}

- (IBAction)imageViewPressed:(UIButton *)sender {
    if ([self.nameTextField.text length] == 0){
        [self.nameTextField becomeFirstResponder];
    }
    else {
        // Present an ActionSheet with the options.
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose an image source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photos", @"Wiki", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) //Cancel
    {
        NSLog(@"Camera Clicked");
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.allowsEditing = YES;
        self.imgPicker.delegate = self;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
    else if (buttonIndex == 1) {
        NSLog(@"Photos Clicked");
        self.imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.allowsEditing = YES;
        self.imgPicker.delegate = self;
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
    else if (buttonIndex == 2) {
        NSLog(@"Wiki Clicked");
        [self performSegueWithIdentifier:@"WikiSegue" sender:self];
    }
//    else if (buttonIndex == 3) {
//        NSLog(@"Twitter Clicked");        
//        [self performSegueWithIdentifier:@"TwitterSegue" sender:self];
//    }
    else {
        NSLog(@"Cancel Clicked");        
        //[actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    // Save the UIImage with the edited properties
    self.imageName = [self.nameTextField.text stringByAppendingFormat:@".jpg"];
    self.imageURLString = nil;
    
    //Save the UIImage to cache with the imageName;
    [imageCacher cacheImage:image withName:self.imageName];
    
    // Dismiss the view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WebViewControllerDelegate Methods

- (void)webViewController:(WebViewController *)controller didCaptureImageNamed:(NSString *)name fromURLString:(NSString *)urlString
{
    self.imageName = name;
    self.imageURLString = urlString;
}

- (void)keyboardNotification:(NSNotification *)notification
{
    if ([self.textView isFirstResponder])
    {
        NSLog(@"Test");
        NSDictionary *dict = [notification userInfo];
        NSValue *value = [dict objectForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect rect = [value CGRectValue];
        CGSize keyboardSize = rect.size;
        UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        self.scrollView.contentInset = insets;
        self.scrollView.scrollIndicatorInsets = insets;
        
        NSLog(@"Keyboard height = %f", keyboardSize.height);
        
        CGRect viewRect = self.view.frame;
        viewRect.size.height -= keyboardSize.height;
        CGPoint scrollPoint = CGPointMake(0, self.textView.frame.origin.y - (keyboardSize.height - 15));
        
        NSLog(@"Scrolling to point %f %f", scrollPoint.x, scrollPoint.y);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
        
        [self scrollViewScrollUp:YES];
    }
    else {
        [self scrollViewScrollUp:NO];
    }
    
}

- (void)scrollViewScrollUp:(BOOL)scrollUp
{
    
    
    if (scrollUp)
    {
    
    }
    else {
        
    }
    
    
}

@end
