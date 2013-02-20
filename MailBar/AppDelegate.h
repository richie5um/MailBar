//
//  AppDelegate.h
//  MailBar
//
//  Created by RichS on 2/8/13.
//  Copyright (c) 2013 Rich Somerfield. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    
    NSStatusItem *_statusItem;
    NSTimer *_mailTimer;
    
    NSDate* _newMailDate;
}


@property (assign) IBOutlet NSWindow *window;

@end
