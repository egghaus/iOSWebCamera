//
//  NSString+ContainsString.m
//  WebCamera
//
//  Created by Shayne Sweeney on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+ContainsString.h"


@implementation NSString (ContainsString)

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

@end
