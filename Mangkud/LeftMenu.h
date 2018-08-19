//
//  LeftMenu.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LeftMenu : UIViewController <UITableViewDelegate,UITableViewDataSource>

{
    AppDelegate *delegate;
    NSMutableIndexSet *expandedSections;
    
    UIViewController *viewController;
}

@property (weak, nonatomic) IBOutlet UIImageView *companyPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (retain, nonatomic) IBOutlet UITableView *myTable;

- (void)updateProfile;
@end
