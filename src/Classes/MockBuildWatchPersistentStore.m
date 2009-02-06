//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "MockBuildWatchPersistentStore.h"

@interface MockBuildWatchPersistentStore (Private)
+ (NSDictionary *) mockServerList;
+ (NSDictionary *) mockServerGroupPatternsList;
+ (NSDictionary *) mockServerNameList;
+ (NSDictionary *) mockProjectDisplayNamesList;
@end

@implementation MockBuildWatchPersistentStore

- (void) dealloc
{
    [servers release];
    [serverGroupPatterns release];
    [serverNames release];
    [projectDisplayNames release];
    [super dealloc];
}

- (id) init
{
    if (self = [super init]) {
        servers = [[[self class] mockServerList] retain];
        serverGroupPatterns =
            [[[self class] mockServerGroupPatternsList] retain];
        serverNames = [[[self class]  mockServerNameList] retain];
        projectDisplayNames =
            [[[self class] mockProjectDisplayNamesList] retain];
    }
    
    return self;
}

# pragma mark BuildWatchPersistentStore

- (void) saveServers:(NSDictionary *)newServers
{
    [servers release];
    servers = [newServers copy];
}

- (NSDictionary *)getServers
{
    return servers;
}

- (void) saveServerGroupPatterns:(NSDictionary *)newServerGroupPatterns
{
    [serverGroupPatterns release];
    serverGroupPatterns = [newServerGroupPatterns copy];
}

- (NSDictionary *)getServerGroupPatterns
{
    return serverGroupPatterns;
}

- (void) saveServerNames:(NSDictionary *)newServerNames
{
    [serverNames release];
    serverNames = [newServerNames copy];
}

- (NSDictionary *) getServerNames
{
    return serverNames;
}

- (void) saveProjDisplayNames:(NSDictionary *)newProjDisplayNames
{
    [projectDisplayNames release];
    projectDisplayNames = [newProjDisplayNames copy];
}

- (NSDictionary *) getProjDisplayNames
{
    return projectDisplayNames;
}

#pragma mark Private methods

+ (NSDictionary *) mockServerList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [NSArray arrayWithObjects:@"Build Watch",
                                  @"Website",
                                  @"Git Website",
                                  nil],
        @"http://builder/my-server/",
        [NSArray arrayWithObjects:@"Mail",
                                  @"Address Book",
                                  @"Safari",
                                  nil],
        @"http://apple.com/builder/",
        [NSArray arrayWithObjects:@"Windows 7",
                                  @"Visual Studio Team System 2007",
                                  @"Microsoft Office System 2009",
                                  nil],
        @"http://microsoft.com/TeamSystem/default.aspx",
        [NSArray arrayWithObjects:@"OpenOffice",
                                  @"KDE",
                                  @"GNOME",
                                  nil],
        @"http://openoffice.org/builds/",
        nil, nil];
}

+ (NSDictionary *) mockServerGroupPatternsList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"^http://builder/my-server/$", @"http://builder/my-server/",
            @"^http://apple.com/builder/$", @"http://apple.com/builder/",
            @"^http://microsoft.com/TeamSystem/default.aspx$",
            @"http://microsoft.com/TeamSystem/default.aspx",
            @"^http://openoffice.org/builds/$",
            @"http://openoffice.org/builds/",
            @".*", @"All", nil];
}

+ (NSDictionary *) mockServerNameList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"My Builds", @"http://builder/my-server/",
            @"Apple Builds", @"http://apple.com/builder/",
            @"Microsoft Builds",
            @"http://microsoft.com/TeamSystem/default.aspx",
            @"OpenOfice Builds", @"http://openoffice.org/builds/", nil];
}

+ (NSDictionary *) mockProjectDisplayNamesList
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Build Watch", @"http://builder/my-server/|Build Watch",
            @"Website", @"http://builder/my-server/|Website",
            @"Git Website", @"http://builder/my-server/|Git Website",
            @"Mail", @"http://apple.com/builder/|Mail",
            @"Address Book", @"http://apple.com/builder/|Address Book",
            @"Safari", @"http://apple.com/builder/|Safari",
            @"Windows 7",
            @"http://microsoft.com/TeamSystem/default.aspx|Windows 7",
            @"Visual Studio Team System 2007", 
            @"http://microsoft.com/TeamSystem/default.aspx|Visual Studio Team System 2007",
            @"Microsoft Office System 2009",
            @"http://microsoft.com/TeamSystem/default.aspx|Microsoft Office System 2009",
            @"OpenOffice", @"http://openoffice.org/builds/|OpenOffice",
            @"KDE", @"http://openoffice.org/builds/|KDE", 
            @"GNOME", @"http://openoffice.org/builds/|GNOME",
            nil];
}

@end
