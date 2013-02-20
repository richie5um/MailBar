//
//  AppDelegate.m
//  MailBar
//
//  Created by RichS on 2/8/13.
//  Copyright (c) 2013 Rich Somerfield. All rights reserved.
//

#import "AppDelegate.h"
#import "Helpers.h"

@implementation AppDelegate

////////////////////////////////////////////////////////////////////////
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Insert code here to initialize your application
    [Helpers showIconInDock:NO];
    
    if ( YES != [Helpers isLaunchAtStartup] ) {
        [Helpers toggleLaunchAtStartup];
    }
}

////////////////////////////////////////////////////////////////////////
-(void)awakeFromNib {
    
    [self initialiseMenuBarIcon];
    [self initialiseTimer];
}

////////////////////////////////////////////////////////////////////////
-(void)initialiseMenuBarIcon {
    
    // Initialise the menubar
    [self updateMenuBarIcon:NO];
}

////////////////////////////////////////////////////////////////////////
-(void)initialiseTimer {
    
    // Fire in 1 min
    _mailTimer = [NSTimer scheduledTimerWithTimeInterval:60.0f
                                                  target:self
                                                selector:@selector(mailTimerEvent:)
                                                userInfo:nil
                                                 repeats:NO];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)mailTimerEvent:(NSTimer*)theTimer {
    
    [self checkForMail];
}

////////////////////////////////////////////////////////////////////////
-(void)checkForMail {
    
    BOOL newMail = NO;
    
    NSString* scriptPath = [[NSBundle mainBundle] pathForResource:@"CheckOutlookMail" ofType:@"scpt" inDirectory:@""];
    NSAppleScript* theScript = [[NSAppleScript alloc] initWithContentsOfURL:[NSURL fileURLWithPath:scriptPath] error:nil];
    
    NSAppleEventDescriptor *resultDescriptor = [theScript executeAndReturnError:nil];
    if ( nil != resultDescriptor ) {
        NSString* stringValue = [resultDescriptor stringValue];
        NSLog(@"Applescript: %@", stringValue);
        NSInteger count = [stringValue integerValue];
        if ( 0 < count ) {
            if ( nil == _newMailDate ) {
                _newMailDate = [NSDate date];
            } else {
                if ( ( 60.0f * 15 ) < [[NSDate date] timeIntervalSinceDate:_newMailDate] ) {
                    newMail = YES;
                }
            }
        } else {
            _newMailDate = nil;
        }
    } else {
        _newMailDate = nil;
    }
    
    [self updateMenuBarIcon:newMail];
    [self initialiseTimer];
}

////////////////////////////////////////////////////////////////////////
-(void)updateMenuBarIcon:(BOOL)newMail {
    
    NSImage *statusIcon;
    
    
    if ( newMail ) {
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        [_statusItem setHighlightMode:YES];
        
        statusIcon = [NSImage imageNamed:@"MailBar.icns"];
        
        CGFloat menuSize = [[NSStatusBar systemStatusBar] thickness];
        CGFloat iconSize = menuSize * .7;

        [statusIcon setSize:NSMakeSize(iconSize, iconSize)];
        [_statusItem setImage:statusIcon];
    } else {
        if ( nil != _statusItem ) {
            [[NSStatusBar systemStatusBar] removeStatusItem:_statusItem];
            _statusItem = nil;
        }
    }
}

@end
