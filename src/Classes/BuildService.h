//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuildService
- (void) refreshDataForServer:(NSString *)serverUrl;
- (void) cancelRefreshForServer:(NSString *)serverUrl;
@end
