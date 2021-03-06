//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildService.h"
#import "BuildServiceDelegate.h"

@interface MockBuildService : NSObject <BuildService> {
    NSObject<BuildServiceDelegate> * delegate;

    NSTimer * timer;
}

@property (nonatomic, retain) IBOutlet NSObject<BuildServiceDelegate> *
    delegate;
@property (nonatomic, retain) NSTimer * timer;

@end