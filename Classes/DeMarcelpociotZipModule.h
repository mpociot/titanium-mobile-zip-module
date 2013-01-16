/**
 * Marcel Pociot 2012
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "SSZipArchive.h"
@interface DeMarcelpociotZipModule : TiModule 
{
    KrollCallback *successCallback;
    KrollCallback *errorCallback;
}

@end
