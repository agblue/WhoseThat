//
//  ImageCache.m
//  WhoseThat
//
//  Created by Danny Tsang on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

#define TMP NSTemporaryDirectory()


@implementation ImageCache

- (void) cacheImage:(UIImage *)image withName:(NSString *)name 
{
    //Format the name into a path properly.
    NSMutableString *tmpStr = [NSMutableString stringWithString:name];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    [tmpStr replaceOccurrencesOfString:@"%" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    NSString *imageName = [NSString stringWithFormat:@"%@",tmpStr];
    NSString *imagePath = [TMP stringByAppendingFormat:imageName];

    // If the file exists, then unable to save.
    if([[NSFileManager defaultManager] fileExistsAtPath: imagePath])
    {
        NSLog(@"WARNING Image '%@' exists at path '%@'.", name, imagePath);
        return;
    }

    // Save as .png or .jpg/.jpeg.
    if([name rangeOfString: @".png" options:NSCaseInsensitiveSearch].location != NSNotFound)
    {
        NSLog(@"Caching Image PNG to '%@'.", imagePath);
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically: YES];
    }
    else if ([name rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
            [name rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            NSLog(@"Caching Image JPG to '%@'.", imagePath);
            [UIImageJPEGRepresentation(image, 100) writeToFile:imagePath atomically: YES];
        }
    else {
        NSLog(@"ERROR Unable to save image named '%@'.", name);
    }
}

- (void) cacheImageAtURL:(NSString *)urlString withName:(NSString *)name
{
    //Build the NSURL.
    NSURL *imageURL = [NSURL URLWithString:urlString];

    //Format the name into a path properly.
    NSMutableString *tmpStr = [NSMutableString stringWithString:name];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    [tmpStr replaceOccurrencesOfString:@"%" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    NSString *imageName = [NSString stringWithFormat:@"%@",tmpStr];
    NSString *imagePath = [TMP stringByAppendingFormat:imageName];

    // Check if the file already exists before caching it.
    if(![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        // The file doesn't exist, grab the image data and store it.
        NSData *data = [[NSData alloc] initWithContentsOfURL:imageURL];
        if (!data) {
            NSLog(@"ERROR Unable to cache image '%@' at URL '%@'.", imageName, [imageURL absoluteString]);
            return;
        }
        
        // Save the Image that is downloaded in the data.
        UIImage *image = [[UIImage alloc] initWithData: data];
        [self cacheImage:image withName:imageName];
    }
}

- (UIImage *)getImageByName:(NSString *)name
{
    // Build the imagePath from the Temp Directory + Name.
    NSMutableString *tmpStr = [NSMutableString stringWithString:name];
    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    [tmpStr replaceOccurrencesOfString:@"%" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
    NSString *imageName = [NSString stringWithFormat:@"%@",tmpStr];

    NSString *imagePath = [TMP stringByAppendingFormat:imageName];
    
    // If the file doesn't exists, then unable to get.
    if(![[NSFileManager defaultManager] fileExistsAtPath: imagePath])
    {
        NSLog(@"ERROR Image '%@' does not exist at path '%@'.", imageName, imagePath);
        return nil;
    }
    
    // Read the cached image.
    NSData *data = [[NSData alloc] initWithContentsOfFile:imagePath];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}



//- (UIImage *) getImageByURL:(NSString *)ImageURLString
//{
//    
//    NSLog(@"RETRIEVING IMAGESTRING '%@'.", ImageURLString);
//
//    NSMutableString *tmpStr = [NSMutableString stringWithString:ImageURLString];
//    [tmpStr replaceOccurrencesOfString:@"/" withString:@"-" options:1 range:NSMakeRange(0, [tmpStr length])];
//    
//    NSString *filename = [NSString stringWithFormat:@"%@",tmpStr];
//    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
//
//    NSLog(@"READING FROM PATH '%@'.", uniquePath);
//
//    UIImage *image;
//    
//    // Check for a cached version
//    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
//    {
//        NSData *data = [[NSData alloc] initWithContentsOfFile:uniquePath];
//        image = [[UIImage alloc] initWithData:data] ; // this is the cached image
//    }
//    else
//    {
//        // get a new one
//        [self cacheImageWithURL:ImageURLString];
//        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ImageURLString]];
//        image = [[UIImage alloc] initWithData:data];
//        
//    }
//    
//    return image;
//}

@end
