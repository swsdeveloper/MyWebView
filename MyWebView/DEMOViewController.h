//
//  AppDelegate.h
//  MyWebView
//
//  Created by Steven Shatz on 2/13/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DEMOViewController : UIViewController <UIWebViewDelegate> {
    
    IBOutlet UIWebView *webPage;
    IBOutlet UITextField *urlbar;
    IBOutlet UIImageView *imview;
}

@property (strong, nonatomic) IBOutlet UIButton *jsAlertButton;

-(IBAction)launch:(id)sender;
-(IBAction)url:(id)sender;

@end
