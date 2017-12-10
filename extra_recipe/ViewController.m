//
//  ViewController.m
//  extra_recipe
//
//  Created by xerub on 13/06/2017.
//  Copyright © 2017 xerub. All rights reserved.
//  Copyright © 2017 1GamerDev. All rights reserved.
//

#import "ViewController.h"
#import "panic.h"
#include <sys/utsname.h>
int welcome_state = 0;

// Main View

@implementation ViewController
int action = 1;
/*
 action = 0; enables experiments
 action = 1; disables experiments
 action = 17; enables experiments, but with iphone 7 (plus) shit
*/
int jailbroken = 0;
int ready = 1;

- (void)viewWillAppear:(BOOL)animated {
    if ([[[NSUserDefaults standardUserDefaults]
         stringForKey:@"action"] isEqual: @"0"]) {
        action = 0;
    } else if ([[[NSUserDefaults standardUserDefaults]
                 stringForKey:@"action"] isEqual: @"1"]) {
        action = 1;
    } else if ([[[NSUserDefaults standardUserDefaults]
                stringForKey:@"action"] isEqual: @"17"]) {
        action = 17;
    } else {
        action = 1;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UILongPressGestureRecognizer *actionToggle = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(jailbreak2:)];
    [_jb addGestureRecognizer:actionToggle];
    _actionLabel.clipsToBounds = YES;
    _actionLabel.layer.cornerRadius = 20.0f;
    [_actionLabel setAlpha:0.0f];
    struct utsname u = { 0 };
    uname(&u);
    NSString *device = [NSString stringWithFormat:@"%s", u.machine];
    if (strstr(u.version, "CydeloadedARM")) {
        [_jb setEnabled:NO];
        [_jb setTitle:@"Jailbroken" forState:UIControlStateDisabled];
    } else {
        jailbroken = -1;
    }
}

- (void)show {
    [_actionLabel setAlpha:0.0f];
    
    if(action == 0) {
        [_actionLabel setText:@"Experiments Enabled"];
    } else if (action == 1) {
        [_actionLabel setText:@"Experiments Disabled"];
    }
    
    [UIView animateWithDuration:1.0f animations:^{
            
    [_actionLabel setAlpha:1.0f];
            
    } completion:^(BOOL finished) {

    [UIView animateWithDuration:1.0f animations:^{
                
    [_actionLabel setAlpha:0.0f];
                
    } completion:^(BOOL finished){ready = 1; _jb.userInteractionEnabled = YES;}];
            
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        UIAlertController *notSetUp = [UIAlertController
                                       alertControllerWithTitle:@"Cydia not installed"
                                       message:@"Cydeload does not install Cydia yet. Please jailbreak with yalu102 first."
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:notSetUp animated:YES completion:nil];
    }
    struct utsname u = { 0 };
    uname(&u);
    if (strstr(u.version, "MarijuanARM")) {
        
        [_jb setEnabled:NO];
        [_jb setTitle:@"Jailbroken" forState:UIControlStateDisabled];
        
        UIAlertController *yalu = [UIAlertController
                                   alertControllerWithTitle:@"Yalu Detected"
                                   message:@"Your device has been jailbroken with Yalu, so you cannot jailbreak with Cydeload."
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *reboot = [UIAlertAction
                                 actionWithTitle:@"Reboot"
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction *action)
                                 {
                                     kern_pan();
                                 }];
        UIAlertAction *close = [UIAlertAction
                                actionWithTitle:@"Close"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    assert(NO);
                                }];
        UIAlertAction *dismiss = [UIAlertAction
                                  actionWithTitle:@"Dismiss"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action)
                                  {
                                  }];
        
        [yalu addAction:reboot];
        [yalu addAction:close];
        [yalu addAction:dismiss];
        
        [self presentViewController:yalu animated:YES completion:nil];
        
    } if (strstr(u.version, "ACydeloaded")) {
        
        [_jb setEnabled:NO];
        [_jb setTitle:@"Jailbroken" forState:UIControlStateDisabled];
        
        UIAlertController *ACydeloaded = [UIAlertController
                                   alertControllerWithTitle:@"ACydeloaded64 Detected"
                                   message:@"ACydeloaded64 was detected, meaning that you are running Alpha 1 of Cydeload. You should reboot to avoid issues."
                                   preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *reboot = [UIAlertAction
                                 actionWithTitle:@"Reboot"
                                 style:UIAlertActionStyleDestructive
                                 handler:^(UIAlertAction *action)
                                 {
                                     kern_pan();
                                 }];
        UIAlertAction *close = [UIAlertAction
                                actionWithTitle:@"Close"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action)
                                {
                                    assert(NO);
                                }];
        UIAlertAction *dismiss = [UIAlertAction
                                  actionWithTitle:@"Dismiss"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction *action)
                                  {
                                  }];
        
        [ACydeloaded addAction:reboot];
        [ACydeloaded addAction:close];
        [ACydeloaded addAction:dismiss];
        
    }
}

- (IBAction)jailbreak:(UIButton *)sender
{
    [_jb setEnabled:NO];
    [_jb setTitle:@"Jailbreaking" forState:UIControlStateDisabled];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(jailbreakContinue)
                                   userInfo:nil
                                    repeats:NO];
}

- (IBAction)jailbreak2:(UIButton *)sender
{
    if(ready == 1 && _jb.state == UIControlStateHighlighted && [_jb.currentTitle isEqual: @"Jailbreak"]) {
    ready = 0;
    _jb.userInteractionEnabled = NO;
    [_jb cancelTrackingWithEvent:nil];
    if(action == 0) {
        struct utsname u = { 0 };
        uname(&u);
        NSString *device = [NSString stringWithFormat:@"%s", u.machine];
        if ([device isEqual: @"iPhone9,1"] || [device isEqual: @"iPhone9,2"] || [device isEqual: @"iPhone9,3"] || [device isEqual: @"iPhone9,4"]) { action = 17; } else { action = 1; }
    } else if (action == 1) {
        action = 0;
    } else if (action == 17) {
        action = 0;
    }
    NSString *actionObject = [NSString stringWithFormat:@"%d", action];
    [[NSUserDefaults standardUserDefaults] setObject:actionObject forKey:@"action"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self show];
    }
}

- (void)jailbreakContinue {
    NSString *status;
    extern int jb_go(int action);
    switch (jb_go(action)) {
        case 0:
            status = @"Jailbroken";
            break;
        case 1:
            status = @"Failed";
            [self er_f];
            break;
        case 2:
            status = @"Unsupported";
            break;
        case 3:
            status = @"Unsupported";
            break;
        case 5:
            status = @"Jailbroken";
            system("killall SpringBoard && sleep 1 && echo 'dlopen(\"/Library/MobileSubstrate/MobileSubstrate.dylib\", RTLD_LAZY)' | cycript -p SpringBoard");
            break;
        case 42:
            kern_pan();
            break;
        default:
            status = @"Failed";
            [self er_f];
            break;
    }
    [_jb setTitle:status forState:UIControlStateDisabled];
}

- (void)er_f {
    UIAlertController *failed = [UIAlertController
                                 alertControllerWithTitle:/*@"extra_recipe failed"*/@"Error"
                                 message:@"Cydeload has failed, please reboot your device."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *reboot = [UIAlertAction
                             actionWithTitle:@"Reboot"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction *action)
                             {
                                 kern_pan();
                             }];
    
    [failed addAction:reboot];
    
    [self presentViewController:failed animated:YES completion:nil];
}

@end

// Welcome Screen

@implementation Welcome

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    struct utsname u = { 0 };
    uname(&u);
    if(![[[NSUserDefaults standardUserDefaults]
          stringForKey:@"welcomed"] isEqual: @"yes"]) {
        [_welcome setAlpha:1.0f];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(fixBorder)
                                       userInfo:nil
                                        repeats:YES];
        _welcome.clipsToBounds = YES;
        CALayer *border = [CALayer layer];
        CGFloat borderWidth = 0.5;
        border.borderColor = [UIColor whiteColor].CGColor;
        border.frame = CGRectMake(0, _continueBtn.frame.size.height - borderWidth, _continueBtn.frame.size.width, _continueBtn.frame.size.height);
        border.borderWidth = borderWidth;
        [_continueBtn.layer addSublayer:border];
        _continueBtn.layer.masksToBounds = YES;
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(fixBorder)
         name:UIDeviceOrientationDidChangeNotification
         object:[UIDevice currentDevice]];
        [_welcome.layer setCornerRadius:10.0f];
    } else {
        UIViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:ViewController animated:NO completion:nil];
    }
    if([[[NSUserDefaults standardUserDefaults]
          stringForKey:@"shown_welcome"] isEqual: @"yes"]) {
        [_welcome setHidden:YES];
    }
}

- (void)reboot {
    kern_pan();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        UIAlertController *notSetUp = [UIAlertController
                                       alertControllerWithTitle:@"Cydia not installed"
                                       message:@"Cydeload does not install Cydia yet. Please jailbreak with yalu102 first."
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:notSetUp animated:YES completion:nil];
    }
    if (welcome_state == 1) {
        [_continueBtn removeTarget:nil
                            action:NULL
                  forControlEvents:UIControlEventAllEvents];
        
        [_continueBtn addTarget:self
                         action:@selector(reboot)
               forControlEvents:UIControlEventTouchUpInside];
        
        [_continueBtn setTitle:@"Reboot" forState:UIControlStateNormal];
    }
}

- (void)fixBorder
{
    _welcome.clipsToBounds = YES;
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 0.5;
    border.borderColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, _continueBtn.frame.size.height - borderWidth, _continueBtn.frame.size.width, _continueBtn.frame.size.height);
    border.borderWidth = borderWidth;
    [_continueBtn.layer addSublayer:border];
    _continueBtn.layer.masksToBounds = YES;
}

- (IBAction)begin:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"shown_welcome"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UIView animateWithDuration:2.5f animations:^{
        _welcome.frame = CGRectOffset(_welcome.frame, 0, 9999);
    } completion:^(BOOL finished) {
        [_welcome setHidden:YES];
    }];
}

- (IBAction)go:(id)sender {
    UIViewController *Go = [self.storyboard instantiateViewControllerWithIdentifier:@"Go"];
    [self presentViewController:Go animated:YES completion:nil];
}

@end

// View Loader

@implementation load
int jbd = 0;

- (void)viewWillAppear:(BOOL)animated {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.5f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        });
    });
    struct utsname u = { 0 };
    uname(&u);
    if (strstr(u.version, "CydeloadedARM")) {} else if (strstr(u.version, "MarijuanARM")) {} else if (strstr(u.version, "ACydeloaded")) {} else { jbd = -1; }
}

- (void)viewDidAppear:(BOOL)animated {
    if(![[[NSUserDefaults standardUserDefaults]
          stringForKey:@"welcomed"] isEqual: @"yes"] && jbd == -1) {
        welcome_state = 0;
        UIViewController *Welcome = [self.storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
        [self presentViewController:Welcome animated:YES completion:nil];
    } else if (![[[NSUserDefaults standardUserDefaults]
                stringForKey:@"welcomed"] isEqual: @"yes"] && jbd != -1) {
        welcome_state = 1;
        UIViewController *Welcome = [self.storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
        [self presentViewController:Welcome animated:YES completion:nil];
    } else {
        UIViewController *ViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self presentViewController:ViewController animated:YES completion:nil];
    }
}

@end

// TOS

@implementation Go

- (void)viewWillAppear:(BOOL)animated {
    self.scrollView.contentSize=CGSizeMake(320, 700);
}

- (void)viewDidLoad {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:0.4f];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"welcomed"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        });
    });
}

@end
