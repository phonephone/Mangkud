//
//  News.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface News : UIViewController <UIWebViewDelegate>
{
    AppDelegate *delegate;
    NSURLRequest *requestURL;
}
@property (nonatomic) NSString *urlString;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIWebView *myWebview;
@end
