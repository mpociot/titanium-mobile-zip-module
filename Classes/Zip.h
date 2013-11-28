//
//  Zip.h
//  zip
//
//  Created by Marcel Pociot on 28.11.13.
//
//

#import <Foundation/Foundation.h>

@protocol ZipDelegate;

@interface Zip : NSObject

+ (BOOL)unpackArchive:(NSString *)archive toPath:(NSString *)path delegate:(id <ZipDelegate>)delegate;

@end


@protocol ZipDelegate <NSObject>

- (void)unpackProgressDidChange:(float)progress;

@end
