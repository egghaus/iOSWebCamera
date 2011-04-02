//
//  NSString+ContainsString.h
//  WebCamera
//
//  Created by Shayne Sweeney on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (ContainsString)

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

@end
