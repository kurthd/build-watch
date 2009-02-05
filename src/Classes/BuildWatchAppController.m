//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "BuildWatchAppController.h"
#import "ServerReport.h"
#import "ProjectReport.h"

@class Server, Project;

@interface BuildWatchAppController (Private)
- (NSArray *) projectIdsForServer:(NSString *)server;
- (void) setActiveServer:(NSString *) activeServer;
- (void) setServers:(NSDictionary *)newServers;
- (void) setServerNames:(NSDictionary *)newServerNames;
- (void) setProjectDisplayNames:(NSDictionary *)newProjectDisplayNames;
+ (NSString *) keyForProject:(NSString *)project andServer:(NSString *)server;
@end

@implementation BuildWatchAppController

@synthesize persistentStore;
@synthesize serverSelector;
@synthesize projectSelector;
@synthesize buildService;

- (void) dealloc
{
    [servers release];
    [serverNames release];
    [projectDisplayNames release];
    [persistentStore release];
    [buildService release];
    [super dealloc];
}

/*
- (id) initWithPersistentStore:(NSObject<ServerPersistentStore> *)persistentStore
             andServerSelector:(NSObject<ServerSelector> *)aServerSelector
{
    if (self = [super init]) {
        serverPersistentStore = [persistentStore retain];
        serverSelector = [aServerSelector retain];
    }
    return self;
}
 */

- (void) start
{
    [self setServers:[persistentStore getServers]];
    [self setServerNames:[persistentStore getServerNames]];
    [self setProjectDisplayNames:[persistentStore getProjDisplayNames]];
    
    NSArray * serverKeys = [servers allKeys];
    
    for (NSString * server in serverKeys)
        [buildService refreshDataForServer:server];
    
    [serverSelector selectServerFrom:serverKeys];

    //
    // 1. Fetch existing data (server list).
    // 2. Start refresh of data from network.
    //     2.1: UI is updated.
    //     2.2: Start network communication.
    // 3. Hand something a list of servers to display.
    // 4. Tell something to display the list. ?
    //
}

#pragma mark Some protocol implementation

- (void) report:(ServerReport *)report receivedFrom:(NSString *)server
{    
    for (ProjectReport * projReport in [report projectReports])
        [projectDisplayNames setObject:projReport.name
                                forKey:[[self class]
                                        keyForProject:projReport.name
                                        andServer:server]];
    
    NSMutableArray * projects = [[NSMutableArray alloc] init];
    
    for (ProjectReport * projReport in [report projectReports])
        [projects addObject:projReport.name];

    [servers setObject:projects forKey:server];

    [projects release];
    
    NSMutableArray * projectIds = [[NSMutableArray alloc] init];
    
    for (ProjectReport * projReport in [report projectReports])
        [projectIds addObject:[[self class]
                               keyForProject:projReport.name
                                   andServer:server]];
    
    if([activeServer isEqual:server])
        [projectSelector selectProjectFrom:projectIds];
    
    [projectIds release];
    
    //
    // 1. Update UI for toolbar.
    // 2. Tell relevant view controller(s) to update themselves.
    //
}

#pragma mark ServerSelectorDelegate protocol implementation

- (void) userDidSelectServer:(NSString *)server
{
    //
    // 1. Load data from model as appropriate.
    // 2. Give data to projects controller.
    // 3. Orchestrate the display of the projects controller's view.
    //

    NSLog(@"User selected server: %@.", server);
    [self setActiveServer:server];
    [projectSelector selectProjectFrom:[self projectIdsForServer:server]];
}

#pragma mark ProjectSelectorDelegate protocol implementation

- (void) userDidSelectProject:(NSString *)project
{
    //
    // 1. Load data from model as appropriate.
    // 2. Give data to project controller.
    // 3. Orchestrate the display of the project controller's view.
    //

    NSLog(@"User selected project: %@.", project);
}

- (void) userDidDeselectServer
{
    [self setActiveServer:nil]; 
}

- (NSString *) displayNameForProject:(NSString *)project
{
    NSString * displayName = [projectDisplayNames objectForKey:project];
    NSAssert1(
        displayName != nil,
              @"Unable to find display name for project %@", project);
    
    return displayName;
}

- (void) userDidHideProjects:(NSArray *)projects
{
    //
    // 1. Update model.
    // 2. Orchestrate the updating of the display. (?)
    // 3. Notify other UI elements of change as needed.
    //
}

- (void) userDidShowProjects:(NSArray *)projects
{
    //
    // 1. Update model.
    // 2. Orchestrate the updating of the display. (?)
    // 3. Notify other UI elements of change as needed.
    //
}

- (void) userDidAddServers:(NSArray *)servers
{
    //
    // 1. Save servers/update model.
    // 2. Start refresh of server data (if necessary).
    // 3. Update server controller's list of servers.
    //
}

- (void) userDidRemoveServers:(NSArray *)servers
{
    //
    // 1. Update model.
    // 2. Update server controller's list of servers.
    //
}

- (NSArray *) projectIdsForServer:(NSString *)server
{
    NSMutableArray * projectIds = [NSMutableArray array];
    
    for (NSString * project in [servers objectForKey:server])
        [projectIds addObject:
         [BuildWatchAppController keyForProject:project andServer:server]];
    
    return projectIds;
}

#pragma mark Accessors

- (void) setActiveServer:(NSString *) server
{
    [server retain];
    [activeServer release];
    activeServer = server;
}

- (void) setServers:(NSDictionary *)newServers
{
    NSMutableDictionary * tempServers = [newServers mutableCopy];
    [servers release];
    servers = tempServers;
}

- (void) setServerNames:(NSDictionary *)newServerNames
{
    NSMutableDictionary * tempServerNames = [newServerNames mutableCopy];
    [serverNames release];
    serverNames = tempServerNames;
}

- (void) setProjectDisplayNames:(NSDictionary *)newProjectDisplayNames;
{
    NSMutableDictionary * tempProjectDisplayNames =
        [newProjectDisplayNames mutableCopy];
    [projectDisplayNames release];
    projectDisplayNames = tempProjectDisplayNames;
}

#pragma mark static utility functions

+ (NSString *) keyForProject:(NSString *)project andServer:(NSString *)server
{
    return [NSString stringWithFormat:@"%@|%@", server, project];
}

@end