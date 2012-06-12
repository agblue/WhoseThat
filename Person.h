//
//  Person.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *notes;
@property (strong, nonatomic) NSString *imageURLString;
@property (strong, nonatomic) NSString *imageName;

@end
