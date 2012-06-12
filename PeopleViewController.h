//
//  PeopleViewController.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddPersonViewController.h"

@interface PeopleViewController : UITableViewController<AddPersonViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *peopleArray;

@end
