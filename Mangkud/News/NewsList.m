//
//  NewsList.m
//  Mangkud
//
//  Created by Firststep Consulting on 31/5/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "NewsList.h"
#import "UIImageView+WebCache.h"
#import "NewsCell.h"
#import "News.h"
#import "AdminChat.h"
#import "AdminChatWeb.h"

@interface NewsList ()

@end

@implementation NewsList

@synthesize myCollectionView,myLayout;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //myLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
    
    //NSLog(@"XXXXXXXX%@",[UIApplication sharedApplication].delegate.window.rootViewController.childViewControllers.firstObject);
    
    [self loadNews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineAction:) name:@"CheckConnection" object:nil];
}

-(void)onlineAction:(NSNotification *)noti
{
    [self loadNews];
    /*
     Reachability* reach = [noti object];
     reach.reachableBlock = ^(Reachability*reach)
     {
     dispatch_async(dispatch_get_main_queue(), ^{
     
     });
     };
     */
}

- (void)loadNews
{
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString* url = [NSString stringWithFormat:@"%@getNewsList",HOST_DOMAIN];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"NewsJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             newsJSON = responseObject;
             
             [myCollectionView reloadData];
             
             //[SVProgressHUD showSuccessWithStatus:[responseObject objectForKey:@"message"]];
             [SVProgressHUD dismiss];
         }
         else{
             [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"message"]];
             //[self alertTitle:@"Fail" detail:[responseObject objectForKey:@"message"]];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error %@",error);
         [SVProgressHUD showErrorWithStatus:@"Please check your internet connection"];
     }];
}

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return [[newsJSON objectForKey:@"data"] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = collectionView.frame.size.width*0.95;
    
    NSDictionary *cellArray = [[newsJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    //TITLE
    CGRect first = [[cellArray objectForKey:@"news_topic"] boundingRectWithSize:CGSizeMake(width*0.9, MAXFLOAT)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName: [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+6]} // change font size accordingly
                                                                        context:nil];
    
    //DATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    NSDate *dateFormated = [dateFormatter dateFromString:[cellArray objectForKey:@"news_date"] ];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];//@"dd.MM.YY HH:mm:ss"
    NSString *dateString = [dateFormatter stringFromDate:dateFormated];
    
    CGRect second = [dateString boundingRectWithSize:CGSizeMake(width*0.9, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-3]} // change font size accordingly
                                             context:nil];
    
    //DETAIL
    CGRect third = [[cellArray objectForKey:@"news_detail"] boundingRectWithSize:CGSizeMake(width*0.9, MAXFLOAT)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName: [UIFont fontWithName:delegate.fontLight size:delegate.fontSize-3]} // change font size accordingly
                                                                         context:nil];
    
    float spaceTopBottom = width*0.06;
    
    //CGFloat heightOfText = [self getTextHeightFromString:[currentObject valueForKey:@"yourKeyName"] ViewWidth:cvWidth WithPading:10];
    
    //get height of each and every text and calculate total height
    
    CGSize rect;
    rect.width = width;
    rect.height = first.size.height+second.size.height+third.size.height+(collectionView.frame.size.width*0.66)+spaceTopBottom;
    return rect;
}

- (CGFloat)getTextHeightFromString:(NSString *)text ViewWidth:(CGFloat)width WithPading:(CGFloat)padding
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"yourFontName" size:16]} // change font size accordingly
                                     context:nil];
    
    return rect.size.height + padding;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 0, 10, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 15.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    NSDictionary *cellArray = [[newsJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    [cell.newsPic sd_setImageWithURL:[NSURL URLWithString:[cellArray objectForKey:@"news_image"]] placeholderImage:[UIImage imageNamed:@"icon1024.png"]];
    
    cell.titleLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+6];
    cell.dateLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-3];
    cell.detailLabel.font = [UIFont fontWithName:delegate.fontLight size:delegate.fontSize-3];
    
    cell.titleLabel.text = [cellArray objectForKey:@"news_topic"];
    
    //DATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    //[dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    NSDate *dateFormated = [dateFormatter dateFromString:[cellArray objectForKey:@"news_date"] ];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];//@"dd.MM.YY HH:mm:ss"
    NSString *dateString = [dateFormatter stringFromDate:dateFormated];
    
    cell.dateLabel.text = dateString;
    cell.detailLabel.text = [cellArray objectForKey:@"news_detail"];
    
    //cell.nameLabel.font = [UIFont fontWithName:@"Kanit-Regular" size:delegate.fontSize+4];
    //[self shorttext:cell.nameLabel];
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellArray = [[newsJSON objectForKey:@"data"] objectAtIndex:indexPath.row];
    
    News *viewController = [[News alloc]initWithNibName:@"News" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
    viewController.urlString = [cellArray objectForKey:@"news_url"];
    //[self.navigationController pushViewController:ofd animated:YES];
}

- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)rightMenu:(id)sender {
    //AdminChat *viewController = [[AdminChat alloc]initWithNibName:@"AdminChat" bundle:nil];
    //[viewController setHidesBottomBarWhenPushed:YES];
    
    AdminChatWeb *viewController = [[AdminChatWeb alloc]initWithNibName:@"AdminChatWeb" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    
    //UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    //[self presentViewController:nav animated:YES completion:nil];
}

- (void)alertTitle:(NSString*)title detail:(NSString*)alertDetail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:alertDetail preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

