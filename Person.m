//
//  Person.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

#define kNAME           @"name"
#define kNOTES          @"notes"
#define kIMAGEURLSTRING @"imageURLString"
#define kIMAGENAME      @"imageName"

@implementation Person

@synthesize name, notes, imageURLString, imageName;


-(void)encodeWithCoder:(NSCoder *)coder {
    NSLog(@"Encoding %@.", self.name);
    [coder encodeObject:self.name forKey:kNAME];
    [coder encodeObject:self.notes forKey:kNOTES];
    [coder encodeObject:self.imageName forKey:kIMAGENAME];
    [coder encodeObject:self.imageURLString forKey:kIMAGEURLSTRING];
}

-(id)initWithCoder:(NSCoder *)coder {
    if((self = [super init])) {
        self.name = [coder decodeObjectForKey:kNAME];
        self.notes = [coder decodeObjectForKey:kNOTES];
        self.imageName = [coder decodeObjectForKey:kIMAGENAME];
        self.imageURLString = [coder decodeObjectForKey:kIMAGEURLSTRING];
        NSLog(@"Decoding %@.", self.name);
    }
    return self;
}

@end
