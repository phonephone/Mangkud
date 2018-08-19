//
//  AdminChatWeb.m
//  Mangkud
//
//  Created by Firststep Consulting on 29/3/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AdminChatWeb.h"
#import "IQKeyboardManager.h"

@interface AdminChatWeb ()

@end

@implementation AdminChatWeb

@synthesize titleLabel,myWebView;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    //[[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+6];
    
    NSString *urlString = [NSString stringWithFormat:@"http://mangkud.co/index.php?login/chatbox/%@",delegate.userID];
    NSURL *url = [NSURL URLWithString:urlString];
    //NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
    
    myWebView.delegate = self;
    myWebView.scrollView.bounces = NO;
    requestURL = [[NSURLRequest alloc] initWithURL:url];
    //[self.webView setAllowsInlineMediaPlayback:YES];
    //self.webView.mediaPlaybackRequiresUserAction = NO;
    [myWebView loadRequest:requestURL];
    
    [SVProgressHUD showWithStatus:@"Loading"];
    //https://github.com/SVProgressHUD/SVProgressHUD
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Did start loading: %@", [[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //self.view.alpha = 1.f;
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"!DidFailLoadWithError: %@", [error description]);
    //self.view.alpha = 1.f;
    [SVProgressHUD showErrorWithStatus:@"Error Please check your internet connection"];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
