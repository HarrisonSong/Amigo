//
//  InviteEventViewController.m
//  Amigo
//
//  Created by Zenan on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "InviteEventViewController.h"
#import "TimelinePostController.h"
#import "EventsController.h"
#import "FBEventCell.h"

@interface InviteEventViewController ()

@property (strong, nonatomic) NSMutableArray *events;

@end

@implementation InviteEventViewController

#pragma mark View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStyling];

    self.events = [[NSMutableArray alloc] init];

    [self loadEvents];
}

- (void)viewDidUnload {
    [self setCancelButton:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    FBEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FBEventCell"];
    [cell setStyling];
    
    EventModel *event = [self.events objectAtIndex:indexPath.row];
    
    
    [cell.eventName setText: event.name];
    [cell.eventDesc setText: event.desc];
    
    //[cell.eventName sizeToFit];
    //[cell.eventDesc sizeToFit];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMM yy, h:mma"];
    
    NSLog(@"cell date %@", event.startTime);
    if(event.startTime) {
        if ([event.endTime compare:event.startTime]) {
            cell.eventTime.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:event.startTime], [dateFormatter stringFromDate:event.endTime]];
        } else {
            cell.eventTime.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:event.startTime]];
        }
    } else {
        cell.eventTime.text = @"Unknown";
    }
    if (event.location) {
        cell.eventLocation.text = event.location;
    } else {
        cell.eventLocation.text = @"Unknown";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventModel *currentEvent = [self.events objectAtIndex:indexPath.row];

    [SVProgressHUD showWithStatus:@"Inviting to Event..." maskType:SVProgressHUDMaskTypeGradient];
    [[TimelinePostController sharedInstance] postEvent:currentEvent ToFriend:self.friendModel complete:^(BOOL success) {
        if (success) {
            [self.delegate composeViewController:self didCompose:currentEvent];
            [SVProgressHUD showSuccessWithStatus:@"Invited to Event!"];
        }
    }];
    
    [EventsController inviteFriend:self.friendModel ToEvent:currentEvent Completion:^(NSError *error) {
    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Helper Methods

- (void)setStyling {
    [self.cancelButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)loadEvents
{
    [EventsController getUserFacebookEventsWithCompletionHandler:^(NSError *error, NSArray *facebookEvents) {
        
        [EventsController getInvitedEventToFriend:self.friendModel Completion:^(NSError *error, NSArray *invitedEvents) {
            
            [self.events removeAllObjects];
            
            NSLog(@"Facebook Events :%@", facebookEvents);
            
            for (EventModel *fbEvent in facebookEvents) {
                
                BOOL isInvited = NO;
                for (EventModel *invitedEvent in invitedEvents) { // Check if already invited
                    if ([fbEvent.fbEventID isEqualToString: invitedEvent.fbEventID]) {
                        isInvited = YES;
                        break;
                    }
                }
                
                if (!isInvited) {
                    [self.events addObject:fbEvent];
                }
                
            }
    
            [self.tableView reloadData];
        }];
    }];
}

@end
