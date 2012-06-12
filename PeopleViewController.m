//
//  PeopleViewController.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PeopleViewController.h"
#import "Person.h"
#import "ImageCache.h"
#import "PersonCell.h"

@interface PeopleViewController ()
{
    ImageCache *imageCacher;
}

@end

@implementation PeopleViewController

@synthesize peopleArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup the ImageCache.
    imageCacher = [[ImageCache alloc] init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.LeftBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    imageCacher = nil;
    self.peopleArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.peopleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    
    // Configure the cell...
    Person *person = [self.peopleArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = person.name;
    cell.textView.text = person.notes;
    
    if (person.imageName != nil)
    {
        UIImage *personImage = [imageCacher getImageByName:person.imageName];
        if (personImage)
        {
            cell.imageView.image = personImage;
        }
        else {
            cell.imageView.image = [UIImage imageNamed:@"silhouette_missing_sm.png"];
        }
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"silhouette_sm.png"];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.peopleArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddPerson"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        AddPersonViewController *addPersonViewController = [navigationController.viewControllers objectAtIndex:0];
        addPersonViewController.delegate = self;
    }
}

#pragma mark - AddPersonViewControllerDelegate Methods

- (void)addPersonViewController:(AddPersonViewController *)controller didReturnWithPerson:(Person *)person  
{
    // Add the person to the array.
    [self.peopleArray addObject:person];
    
    // Insert the row into the table.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.peopleArray indexOfObject:person] inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    //Dismiss the viewcontroller.
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void)addPersonViewControllerDidCancel:(AddPersonViewController *)controller
{
    // Dismiss the viewcontroller.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
