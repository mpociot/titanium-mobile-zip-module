/**
 * Titanium Module Copyright (c) Marcel Pociot 2012
 *
 * ZipArchive Class
 *  Created by aish on 08-9-11.
 *  acsolu@gmail.com
 *  Copyright 2008  Inc. All rights reserved.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "DeMarcelpociotZipModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation DeMarcelpociotZipModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"dcf69df6-7244-4fe5-b38b-c81058f4e8d7";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"de.marcelpociot.zip";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
    RELEASE_TO_NIL(successCallback);
    RELEASE_TO_NIL(progressCallback);
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(void)unzip:(id)args
{
    RELEASE_TO_NIL(successCallback);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    TiFile *file        = [args objectForKey:@"file"];
    NSString *filename  = [(TiFile*)file path];
    NSString *target    = [args objectForKey:@"target"];
    successCallback     = [[args objectForKey:@"success"] retain];
    progressCallback      = [[args objectForKey:@"progress"] retain];
    errorCallback       = [[args objectForKey:@"error"] retain];
    bool overwrite      = [TiUtils boolValue:[args objectForKey:@"overwrite"] def:YES];
    
    NSURL *targetUrl    = [NSURL URLWithString:target];
    NSString *newtarget = [targetUrl path];
    
    BOOL result = [Zip unpackArchive:filename toPath:newtarget delegate:self];
    if( result ){
        if( successCallback != nil ){
            NSDictionary *event = [NSDictionary 
                                   dictionaryWithObjectsAndKeys:
                                   newtarget,@"target",
                                   nil];
            [self _fireEventToListener:@"success" withObject:event listener:successCallback thisObject:nil];
        }
    } else {
        if( errorCallback != nil ){
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:filename,@"path", nil];
            [self _fireEventToListener:@"error" withObject:event listener:errorCallback thisObject:nil];
        }
    }
}


#pragma mark - ZipDelegate

- (void)unpackProgressDidChange:(float)progress
{
    if ( progressCallback != nil ) {
        dispatch_async( dispatch_get_main_queue(), ^{
            NSDictionary *event = [NSDictionary
                                   dictionaryWithObjectsAndKeys:
                                   @(progress),@"progress",
                                   nil];
            NSArray *args = [NSArray arrayWithObject:event];
            NSLog(@"Progress: %f",progress);
            [progressCallback call:args thisObject:nil];
        });
    } else {
        NSLog(@"No Eventlistener");
    }
}

@end
