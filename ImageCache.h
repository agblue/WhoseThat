//
//  ImageCache.h
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject


- (void)cacheImage:(UIImage *)image withName:(NSString *)name;
- (void)cacheImageAtURL:(NSString *)urlString withName:(NSString *)name;

- (UIImage *)getImageByName:(NSString *)name;
//- (UIImage *)getImageByURL:(NSString *)imageURLString;

@end
