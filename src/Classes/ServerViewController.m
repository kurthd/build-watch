//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ServerViewController.h"
#import "BuildWatchAppDelegate.h"
#import "ProjectsViewController.h"

@implementation ServerViewController

@synthesize tableView;
@synthesize serverGroupNames;
@synthesize visibleServerGroupNames;
@synthesize delegate;

- (void) dealloc
{
    [tableView release];
    [serverGroupNames release];
    [visibleServerGroupNames release];
    [delegate release];
    [addBarButtonItem release];
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Servers";

    addBarButtonItem = [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                              target:self
                              action:@selector(addServer)];

    [self.navigationItem setRightBarButtonItem:addBarButtonItem animated:NO];
    [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:NO];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath * selectedRow = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selectedRow animated:NO];

    self.navigationItem.leftBarButtonItem.enabled =
        visibleServerGroupNames.count > 0;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [tableView setEditing:NO animated:NO];
}

#pragma mark UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tv
  numberOfRowsInSection:(NSInteger)section
{
    return visibleServerGroupNames.count;
}

- (UITableViewCell *) tableView:(UITableView *)tv
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell * cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];

    // Set up the cell
    cell.text = [visibleServerGroupNames objectAtIndex:indexPath.row];

    return cell;
}

- (void)      tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate
     userDidSelectServerGroupName:[visibleServerGroupNames objectAtIndex:indexPath.row]];
}

- (UITableViewCellAccessoryType) tableView:(UITableView *)tv
          accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark Server manipulation buttons

- (void)addServer
{
    NSString * title = @"All your server are belong to us";
    NSString * message = @"This feature has not yet been implemented.";
    NSString * cancelTitle = @"Make Your Time";

    UIAlertView * alert = [[[UIAlertView alloc]
        initWithTitle:title
              message:message
             delegate:self
    cancelButtonTitle:cancelTitle
    otherButtonTitles:nil] autorelease];

    [alert show];
}

- (void)editServers
{
    [tableView setEditing:YES animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];

    NSMutableArray * indexPaths = [NSMutableArray array];
    NSMutableArray * visible = [NSMutableArray array];

    for (NSInteger i = 0; i < serverGroupNames.count; ++i) {
        NSString * serverGroupName = [serverGroupNames objectAtIndex:i];
        if ([delegate canServerGroupBeDeleted:serverGroupName])
            [visible addObject:serverGroupName];
        else
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }

    [tableView beginUpdates];
    [tableView setEditing:editing animated:animated];

    if (editing) {
        self.visibleServerGroupNames = visible;
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
        [tableView deleteRowsAtIndexPaths:indexPaths
                         withRowAnimation:UITableViewRowAnimationTop];
    } else {
        self.visibleServerGroupNames = serverGroupNames;
        [self.navigationItem
            setRightBarButtonItem:addBarButtonItem animated:YES];
        [tableView insertRowsAtIndexPaths:indexPaths
                         withRowAnimation:UITableViewRowAnimationTop];
    }

    [tableView endUpdates];
}

#pragma mark Accessors

- (void)setServerGroupNames:(NSArray *)someServerGroupNames
{
    [someServerGroupNames retain];
    [serverGroupNames release];
    serverGroupNames = someServerGroupNames;

    self.visibleServerGroupNames = serverGroupNames;
    
    [tableView reloadData];
}

@end
