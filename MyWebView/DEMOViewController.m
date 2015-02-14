//
//  AppDelegate.h
//  MyWebView
//
//  Created by Steven Shatz on 2/13/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

// Assignment:
// UIWebview:
//  goal: communicate 2 ways between js and objective-c
//      1. make an html page with an html button that NSLogs when you click it
//      2. add an iOS button that creates a javascript alert when you click it.

// Noteworthy References:
// - HTML button triggers ObjC Method: http://stackoverflow.com/questions/15537320/invoke-method-in-objective-c-code-from-html-code-using-uiwebview
// - UIAlertController: http://useyourloaf.com/blog/2014/09/05/uialertcontroller-changes-in-ios-8.html
// - JavaScript Alert: http://www.w3schools.com/js/js_popup.asp


#import "DEMOViewController.h"
#import "Constants.h"


@interface DEMOViewController () {
    UIWebView *webView;
}

@end

@implementation DEMOViewController


    // UIWebView methods:
    // -- loadRequest : initiates asynch client request
    // -- stopLoading : cancels the action (triggered via xib's STOP button)
    // -- reload      : reloads the current page (xib's RELOAD button)
    // -- goBack      : xib's REWIND button
    // -- goForward   : xib's FAST FORWARD button
    //
    // UIWebView properties:
    // -- loading = YES while url is being downloaded


- (void)viewDidLoad {
    NSLog(@"%s", __FUNCTION__);
    
    imview.image = [UIImage imageNamed:@"logo.png"];
    
    [self launch:self];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - Action Methods

// The xib's HOME button and ViewDiDLoad (above) trigger this action
-(IBAction)launch:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    webPage.delegate = self;
    
    // Original home page: Google
    // NSURL *homeURL = [NSURL URLWithString:@"http://www.google.com"];
    // [webPage loadRequest:[NSURLRequest requestWithURL:homeURL]];

    NSString *htmlName = @"StevensWebPage2";
    NSString *htmlExt = @".html";
    NSURL *urlquery = [[NSBundle mainBundle] URLForResource:htmlName withExtension:htmlExt];
    
    [webPage loadRequest:[NSURLRequest requestWithURL:urlquery]];
}

// The xib's UITextField (urlbar) triggers this action when "Did End On Exit" occurs
-(IBAction)url:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    
    NSString *query = [urlbar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURL *urlquery = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",query]];
    
    [webPage loadRequest:[NSURLRequest requestWithURL:urlquery]];
}

- (IBAction)jsAlertButtonTapped:(id)sendir {
    NSLog(@"\"JS Alert\" Button tapped...");
    
    // [self displayStandardIosAlert];

    /* Three types of JavaScript Dialogue Boxes:
        1. Alert:
            <a href="#" onClick="alert('Thanks for the click')">Click me</a>
            Displays alert with OK button
        2. Confirm:
            <a href="#" onClick="confirm('Are you sure?')">Click me</a>
            Displays alert with OK and Cancel buttons
        3. Prompt:
            <a href="#" onClick="prompt('What is your name?')">Click me</a>
            Displays alert with text field, and OK and Cancel buttons
     */
    
    //NSString *alertType = [NSString stringWithFormat:@"displayJsAlert()"];    // Press OK
    NSString *alertType = @"displayJsConfirm()";                                // Press Cancel or OK
    
    NSString *jsCallBack = alertType;
    NSString *returnValue = [webPage stringByEvaluatingJavaScriptFromString:jsCallBack];    // invoke JS function in web page
    NSLog(@"%@",returnValue);                                                 
}

- (void)displayStandardIosAlert {
    //NSLog(@"%s", __FUNCTION__);
    
    NSString *alertTitle = @"WARNING!!!";
    NSString *alertMessage = @"JavaScript Alert Button Was Tapped";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")   // (key is displayed,comment is for internal use only)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIWebView Delegate Methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%s, navType: %ld", __FUNCTION__, navigationType);
    
    // This rtn is called whenever a web page begins loading a frame
    // If StevensWebPage2 is the current web page and user clicks the button on that page, that button invokes our method webToNativeCall
    // webToNativeCall must trigger a new frame load, so we come here first (and navigationType = UIWebViewNavigationTypeOther)
    
    if ([[[request URL] absoluteString] hasPrefix:@"ios:"]) {
        [self performSelector:@selector(webToNativeCall)];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - Method invoked by StevensWebPage2.html

- (void)webToNativeCall {
    NSLog(@"%s", __FUNCTION__);
    
    // The web page's locationChange() JavaScript function invokes this routine
    // This rtn causes
    // This routine then calls the web page's getText() function to get the text from the web page's text box
    
    NSString *returnvalue = [webPage stringByEvaluatingJavaScriptFromString:@"getText()"];
    NSLog(@"\n\"Click Me\" button tapped...\nYou entered: %@\n", returnvalue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
