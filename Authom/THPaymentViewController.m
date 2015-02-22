//
//  THPaymentViewController.m
//  Authom
//
//  Created by Mimee Xu on 2/21/15.
//  Copyright (c) 2015 Mimee Xu. All rights reserved.
//

#import "THPaymentViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Braintree/Braintree.h>
#import "ViewController.h"

#define kFirechatNS @"https://authom.firebaseio.com"

@interface THPaymentViewController ()

@property (nonatomic, strong) NSDictionary *colorTable;
@property (nonatomic) BOOL newMessagesOnTop;

@end

@implementation THPaymentViewController


-(UIColor *) generateRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5];
    return color;
}



- (void)handleNetwork {
    NSString *baseUrl = @"/token.json";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:baseUrl
      parameters:@{ @"server-auth": @"token", @"customer-session": @"session"}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // Setup braintree with responseObject[@"client_token"]
             // self.braintree = [Braintree braintreeWithClientToken:responseObject[@"client_token"]];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // Handle failure communicating with your server
         }];
}
#pragma mark - Setup

// Initialization.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize array that will store chat messages.
    self.chat = [[NSMutableArray alloc] init];
    self.colorTable = [[NSMutableDictionary alloc] init];
    // Initialize the root of our Firebase namespace.
    self.firebase = [[Firebase alloc] initWithUrl:kFirechatNS];
    
    // Pick a random number between 1-1000 for our username.
    self.name = [NSString stringWithFormat:@"Guest%d", arc4random() % 1000];
    [self.nameField setTitle:self.name forState:UIControlStateNormal];
    [self.nameField addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController setTitle:self.name];
    [self.nameNavBar.topItem setTitle:self.name];
    [self.doneButton setTintColor:[UIColor whiteColor]];

    // Decide whether or not to reverse the messages
    self.newMessagesOnTop = YES;
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if (self.newMessagesOnTop) {
            [self.chat insertObject:snapshot.value atIndex:0];
        } else {
            [self.chat addObject:snapshot.value];
        }
        
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self.tableView reloadData];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Text field handling

// This method is called when the user enters text in the text field.
// We add the chat message to our Firebase.
- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    
    // This will also add the message to our local array self.chat because
    // the FEventTypeChildAdded event will be immediately fired.
    /*  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
     CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
     CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
     */
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    
    
    UIColor *color = [self.colorTable objectForKey:self.name];
    if (color) {
        [color getHue:&hue
            saturation:&saturation
            brightness:&brightness
                 alpha:&alpha];
    }
    else {
        hue =(arc4random() % 256/256.0);
        saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
        brightness = ( arc4random() % 128 / 256.0 );

        [self.colorTable setValue:[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.4] forKey:self.name];
    }
    [[self.firebase childByAutoId] setValue:@{@"name" : self.name,
                                              @"text": aTextField.text,
                                              @"hue": [NSNumber numberWithDouble:hue],
                                              @"saturation": [NSNumber numberWithDouble:saturation],
                                              @"brightness": [NSNumber numberWithDouble:brightness]
                                              }];
    [aTextField setText:@""];
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // We only have one section in our table view.
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    // This is the number of chat messages.
    return [self.chat count];
}

// This method changes the height of the text boxes based on how much text there is.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    NSString *text = @"";
    //add nullguard
    if ([chatMessage class] == [NSDictionary class]) {
        text = chatMessage[@"text"];
    }
    // typical textLabel.frame = {{10, 30}, {260, 22}}
    const CGFloat TEXT_LABEL_WIDTH = 260;
    CGSize constraint = CGSizeMake(TEXT_LABEL_WIDTH, 20000);
    
    // typical textLabel.font = font-family: "Helvetica"; font-weight: bold; font-style: normal; font-size: 18px
    //    CGSize size = [text boundingRectWithSize:constraint options:nil attributes:@{} context:nil];
   // CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect textRect = [text boundingRectWithSize:constraint
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}
                                         context:nil];
    
    CGSize size = textRect.size;
    
    const CGFloat CELL_CONTENT_MARGIN = 22;
    CGFloat height = MAX(CELL_CONTENT_MARGIN + size.height, 44);
    
    return height;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)index
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary* chatMessage = [self.chat objectAtIndex:index.row];
    
    cell.textLabel.text = chatMessage[@"text"];
    cell.detailTextLabel.text = chatMessage[@"name"];
    
    //Styling the cell
    UIColor *color = [UIColor colorWithHue:[chatMessage[@"hue"] floatValue] saturation:[chatMessage[@"saturation"] floatValue] brightness:[chatMessage[@"brightness"] floatValue]  alpha:0.4 ];
    if (!color) {
        color = [self.colorTable objectForKey:chatMessage[@"name"]];
    }
    if (!color) {
        color = [self generateRandomColor];
        [self.colorTable setValue:color forKey:chatMessage[@"name"]];
    }
    [cell setBackgroundColor:color];
//    [cell.textLabel setTextColor:[UIColor whiteColor]];

    return cell;
}

#pragma mark - Keyboard handling

// Subscribe to keyboard show/hide notifications.
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

// Unsubscribe from keyboard show/hide notifications.
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Setup keyboard handlers to slide the view containing the table view and
// text field upwards when the keyboard shows, and downwards when it hides.
- (void)keyboardWillShow:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    [self moveView:[notification userInfo] up:NO];
}

- (void)moveView:(NSDictionary*)userInfo up:(BOOL)up
{
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
     getValue:&keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]
     getValue:&animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]
     getValue:&animationDuration];
    
    // Get the correct keyboard size to we slide the right amount.
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);
    
    [UIView commitAnimations];
}

// This method will be called when the user touches on the tableView, at
// which point we will hide the keyboard (if open). This method is called
// because UITouchTableView.m calls nextResponder in its touch handler.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

#pragma mark -Style
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
