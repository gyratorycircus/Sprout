//
//  AppCenterLogger.m
//
//  Part of "Sprout" https://github.com/levigroker/Sprout
//
//  Created by Levi Brown on March 20, 2019.
//  Copyright (c) 2019 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "AppCenterLogger.h"

@implementation AppCenterLogger

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceQueue;
    static AppCenterLogger *retVal = nil;
    
    dispatch_once(&onceQueue, ^{ retVal = [[self alloc] init]; });
    return retVal;
}

- (MSLogLevel)msLogLevelForDDLogLevel:(DDLogLevel)ddLogLevel
{
	switch (ddLogLevel) {
		case DDLogLevelOff:
			return MSLogLevelNone;
		case DDLogLevelError:
			return MSLogLevelError;
		case DDLogLevelWarning:
			return MSLogLevelWarning;
		case DDLogLevelInfo:
			return MSLogLevelInfo;
		case DDLogLevelDebug:
			return MSLogLevelDebug;
		case DDLogLevelVerbose: // Fall through
		case DDLogLevelAll: // Fall through
		default: // Fall through
			return MSLogLevelVerbose;
	}
}

- (void)logMessage:(DDLogMessage *)logMessage
{
    NSString *logMsg = logMessage->_message;
    
    if (_logFormatter) {
        logMsg = [_logFormatter formatLogMessage:logMessage];
    }
    
    if (logMsg) {
		MSLogLevel msLogLevel = [self msLogLevelForDDLogLevel:logMessage->_level];
		[MSLogger logMessage:^NSString *{
			return logMsg;
		} level:msLogLevel tag:[logMessage->_tag description] file:[logMessage->_file UTF8String] function:[logMessage->_function UTF8String] line:(uint)logMessage->_line];
	}
}

- (NSString *)loggerName
{
	return @"sprout.cocoalumberjack.appcenterlogger";
}

		 
@end
