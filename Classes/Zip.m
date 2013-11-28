//
//  Zip.m
//  zip
//
//  Created by Marcel Pociot on 28.11.13.
//
//

#import "Zip.h"
#import "unzip.h"

@implementation Zip

+ (BOOL)unpackArchive:(NSString *)archive toPath:(NSString *)path delegate:(id <ZipDelegate>)delegate
{
	NSFileManager *fm = [NSFileManager defaultManager];
	[fm removeItemAtPath:[path stringByAppendingPathComponent:@"Pages"] error:nil];
    
	unzFile zip = unzOpen( [archive UTF8String] );
	if( zip == NULL )
	{
		NSLog( @"unzip: zipfile error at unzOpen" );
		return NO;
	}
    
    if( delegate )
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            [delegate unpackProgressDidChange:0];
        });
    }
    
	BOOL success = NO;
    
	unz_global_info gi;
	int err = unzGetGlobalInfo( zip, &gi );
	if( err != UNZ_OK )
		NSLog( @"unzip: zipfile error at unzGetGlobalInfo (%d)", err );
	else
	{
		const unsigned int bufferLength = 4096;
		char buffer[bufferLength];
        
		int progress = -1;
        
		for( uLong i = 0; i < gi.number_entry; ++i )
		{
			int newProgress = i * 100 / gi.number_entry;
			if( newProgress != progress )
			{
				progress = newProgress;
                
                if( delegate )
                {
                   [delegate unpackProgressDidChange:progress / 100.f];
                }
			}
            
			unz_file_info fi;
			err = unzGetCurrentFileInfo( zip, &fi, buffer, bufferLength, NULL, 0, NULL, 0 );
			if( err == UNZ_OK )
			{
				if( fi.size_filename >= bufferLength )
				{
					NSLog( @"unzip: filename buffer is too short, skipping a file!" );
					break;
				}
                
				NSString *fileName = [[NSString stringWithCString:buffer encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                
				BOOL isResourceFork = [fileName hasPrefix:@"__MACOSX/"];
                
				if( !isResourceFork )
				{
					BOOL isDirectory = [fileName hasSuffix:@"/"];
					NSString *fullPath = [path stringByAppendingPathComponent:fileName];
                    
//                    NSLog( @"%s Writing  file %@", __PRETTY_FUNCTION__, fullPath );
					if( isDirectory )
					{
						[fm createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
					}
					else
					{
						FILE *file = fopen( [fullPath UTF8String], "w" );
						if( file == NULL )
						{
							[fm createDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
							file = fopen( [fullPath UTF8String], "w" );
						}
                        
						if( file == NULL )
							NSLog( @"%s can't open file for writing for file %@", __PRETTY_FUNCTION__, fileName );
						else
						{
							err = unzOpenCurrentFile( zip );
							if( err == UNZ_OK )
							{
								int length = unzReadCurrentFile( zip, buffer, bufferLength );
								while( length > 0 )
								{
									fwrite( buffer, length, 1, file );
                                    
									length = unzReadCurrentFile( zip, buffer, bufferLength );
								}
                                
								if( length < 0 )
									NSLog( @"%s unzReadCurrentFile returned length: %d", __PRETTY_FUNCTION__, length );
                                
								err = unzCloseCurrentFile( zip );
								if( err != UNZ_OK )
									NSLog( @"%s unzCloseCurrentFile error: %d", __PRETTY_FUNCTION__, err );
							}
							else
							{
								NSLog( @"%s unzOpenCurrentFile error: %d", __PRETTY_FUNCTION__, err );
							}
                            
							fclose( file );
						}
                        
					}
				}
			}
            
			err = unzGoToNextFile( zip );
			if( err != UNZ_OK && err != UNZ_END_OF_LIST_OF_FILE )
			{
				NSLog( @"unzip: zipfile error at unzGoToNextFile (%d)", err );
				break;
			}
		}
        
		success = YES;
	}
    
	unzClose( zip );
	
	return success;
}

@end
