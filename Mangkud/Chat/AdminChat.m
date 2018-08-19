//
//  AdminChat.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "AdminChat.h"
#import "JSONModel.h"

@interface AdminChat ()
{
    ZHCAudioMediaItem *currentAudioItem;
    NSTimer *timer;
}
@end

@implementation AdminChat

@synthesize titleLabel;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.menuContainerViewController.panMode = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    titleLabel.font = [UIFont fontWithName:delegate.fontBold size:delegate.fontSize+6];
    
    self.messageTableView.estimatedRowHeight = 50.0;
    [[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted){
        if (!granted) {
            //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Remind" message:@"The microphone cannot access will affect the recording function!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alertView show];
        }
    }];
    /**
     *  Load up our fake data for the demo
     */
    self.messages = [NSMutableArray new];
    [self loadMessages];
    self.title = @"ZHCMessages";
    ZHCWeakSelf;
    if (self.automaticallyScrollsToMostRecentMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollToBottomAnimated:NO];
        });
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Test if there is a lot of information, whether it will cause a meal.
    
    /*timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer *timer){
     static long long  index = 0;
     NSString *string = [NSString stringWithFormat:@"Hello Word 您好，你先定一个小目标，比如先赚他个%lld万,那就成功了！",index++];
     ZHCMessage *message = [[ZHCMessage alloc] initWithSenderId:kZHCDemoAvatarIdCook
     senderDisplayName:kZHCDemoAvatarDisplayNameCook
     date:[NSDate date]
     text:string];
     
     [self.demoData.messages addObject:message];
     
     [self finishSendingMessageAnimated:NO];
     
     }];*/
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (currentAudioItem) {
        [currentAudioItem stopPlay];
    }
    
}

#pragma mark - ZHCMessagesTableViewDataSource

-(NSString *)senderDisplayName
{
    return kAvatarDisplayNameSender;
}


-(NSString *)senderId
{
    return kAvatarIdSender;
}

-(void)loadMessages
{
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    ZHCMessagesAvatarImageFactory *avatarFactory = [[ZHCMessagesAvatarImageFactory alloc] initWithDiameter:kZHCMessagesTableViewCellAvatarSizeDefault];
    ZHCMessagesAvatarImage *reciverImage= [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"company_logo"]];
    ZHCMessagesAvatarImage *senderImage = [avatarFactory avatarImageWithImage:[UIImage imageNamed:@"itachi"]];
    
    self.avatars = @{kAvatarIdReciever : reciverImage,
                     kAvatarIdSender : senderImage};
    
    
    self.users = @{ kAvatarIdReciever : kAvatarDisplayNameReciever,
                    kAvatarIdSender : kAvatarDisplayNameSender};
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    ZHCMessagesBubbleImageFactory *bubbleFactory = [[ZHCMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor zhc_messagesBubbleBlueColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor zhc_messagesBubbleGreenColor]];
    
    
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"data" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *array = [dic objectForKey:@"feed"];
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        JSONModel *model = [[JSONModel alloc]initWithDictionary:dic];
        [muArray addObject:model];
    }
    
    for (NSUInteger i=0;i<muArray.count;i++) {
        JSONModel *model = [muArray objectAtIndex:i];
        NSString *avatarId = nil;
        NSString *displayName = nil;
        if (i%3== 0) {
            avatarId = kAvatarIdReciever;
            displayName = kAvatarDisplayNameReciever;
        }else{
            avatarId = kAvatarIdSender;
            displayName = kAvatarDisplayNameSender;
        }
        ZHCMessage *message = [[ZHCMessage alloc]initWithSenderId:avatarId senderDisplayName:displayName date:[NSDate date] text:model.content];
        [self.messages addObject:message];
    }
}

- (id<ZHCMessageData>)tableView:(ZHCMessagesTableView*)tableView messageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

-(void)tableView:(ZHCMessagesTableView *)tableView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messages removeObjectAtIndex:indexPath.row];
}


- (nullable id<ZHCMessageBubbleImageDataSource>)tableView:(ZHCMessagesTableView *)tableView messageBubbleImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your TableView view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
    if (message.isMediaMessage) {
        NSLog(@"is mediaMessage");
    }
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
    
}

- (nullable id<ZHCMessageAvatarImageDataSource>)tableView:(ZHCMessagesTableView *)tableView avatarImageDataForCellAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    //return nil;
    
    ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
    return [self.avatars objectForKey:message.senderId];
}


-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.row %3 == 0) {
        ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
        return [[ZHCMessagesTimestampFormatter sharedFormatter]attributedTimestampForDate:message.date];
    }
    return nil;
}


-(NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if ((indexPath.row - 1) > 0) {
        ZHCMessage *preMessage = [self.messages objectAtIndex:(indexPath.row - 1)];
        if ([preMessage.senderId isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
    
}


- (NSAttributedString *)tableView:(ZHCMessagesTableView *)tableView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - Adjusting cell label heights
-(CGFloat)tableView:(ZHCMessagesTableView *)tableView heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    CGFloat labelHeight = 0.0f;
    if (indexPath.row % 3 == 0) {
        labelHeight = kZHCMessagesTableViewCellLabelHeightDefault;
    }
    return labelHeight;
    
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    CGFloat labelHeight = kZHCMessagesTableViewCellLabelHeightDefault;
    ZHCMessage *currentMessage = [self.messages objectAtIndex:indexPath.row];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        labelHeight = 0.0f;
    }
    
    if (indexPath.row - 1 > 0) {
        ZHCMessage *previousMessage = [self.messages objectAtIndex:indexPath.row - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            labelHeight = 0.0f;
        }
    }
    
    return labelHeight;
}


-(CGFloat)tableView:(ZHCMessagesTableView *)tableView  heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *string = [self tableView:tableView attributedTextForCellBottomLabelAtIndexPath:indexPath];
    if (string) {
        return kZHCMessagesTableViewCellSpaceDefault;
    }else{
        return 0.0;
    }
}

#pragma mark - ZHCMessagesTableViewDelegate
-(void)tableView:(ZHCMessagesTableView *)tableView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didTapAvatarImageView:avatarImageView atIndexPath:indexPath];
}


-(void)tableView:(ZHCMessagesTableView *)tableView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didTapMessageBubbleAtIndexPath:indexPath];
    // Do something
    
    ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
    if (message.isMediaMessage) {
        if ([message.media isKindOfClass:[ZHCPhotoMediaItem class]]) {
            //            ZHCPhotoMediaItem *photoMedia = (ZHCPhotoMediaItem *)message.media;
            //            UIImage *img = photoMedia.image;
            NSLog(@"Photo");
        }else if ([message.media isKindOfClass:[ZHCVideoMediaItem class]]){
            //            ZHCVideoMediaItem *videoMedia = (ZHCVideoMediaItem *)message.media;
            //            NSURL *videoUrl = videoMedia.fileURL;
            NSLog(@"Video");
        }
    }
}


-(void)tableView:(ZHCMessagesTableView *)tableView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    [super tableView:tableView didTapCellAtIndexPath:indexPath touchLocation:touchLocation];
}


-(void)tableView:(ZHCMessagesTableView *)tableView performAction:(SEL)action forcellAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    [super tableView:tableView performAction:action forcellAtIndexPath:indexPath withSender:sender];
    
    NSLog(@"performAction:%ld",(long)indexPath.row);
}


#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(UITableViewCell *)tableView:(ZHCMessagesTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCMessagesTableViewCell *cell = (ZHCMessagesTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}



#pragma mark Configure Cell Data
- (void)configureCell:(ZHCMessagesTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ZHCMessage *message = [self.messages objectAtIndex:indexPath.row];
    if (!message.isMediaMessage) {
        if ([message.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }else{
            cell.textView.textColor = [UIColor whiteColor];
        }
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
}


#pragma mark - Messages view controller

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<ZHCMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    ZHCMessage *message = [[ZHCMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
    
}


#pragma mark - ZHCMessagesInputToolbarDelegate
-(void)messagesInputToolbar:(ZHCMessagesInputToolbar *)toolbar sendVoice:(NSString *)voiceFilePath seconds:(NSTimeInterval)senconds
{
    NSData * audioData = [NSData dataWithContentsOfFile:voiceFilePath];
    ZHCAudioMediaItem *audioItem = [[ZHCAudioMediaItem alloc] initWithData:audioData];
    audioItem.delegate = self;
    ZHCMessage *audioMessage = [ZHCMessage messageWithSenderId:self.senderId
                                                   displayName:self.senderDisplayName
                                                         media:audioItem];
    
    [self.messages addObject:audioMessage];
    
    [self finishSendingMessageAnimated:YES];
    
    
    //    NSFileManager *manager = [NSFileManager defaultManager];
    //    NSDictionary *dic = [manager attributesOfItemAtPath:voiceFilePath error:nil];
    //    long long size = [dic fileSize];
    //    NSLog(@"fileSize:%@",voiceFilePath);
    //    NSLog(@"fileSize:%lld",size/1024);
}



#pragma mark - ZHCMessagesMoreViewDelegate

-(void)messagesMoreView:(ZHCMessagesMoreView *)moreView selectedMoreViewItemWithIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:{//Camera
            [self addVideoMediaMessage];
            [self.messageTableView reloadData];
            [self finishSendingMessage];
        }
            break;
            
        case 1:{//Photos
            [self addPhotoMediaMessage];
            [self.messageTableView reloadData];
            [self finishSendingMessage];
        }
            break;
            
        case 2:{//Location
            typeof(self) __weak weakSelf = self;
            __weak ZHCMessagesTableView *weakView = self.messageTableView;
            [self addLocationMediaMessageCompletion:^{
                [weakView reloadData];
                [weakSelf finishSendingMessage];
                
            }];
        }
            
            break;
            
        default:
            break;
    }
}


#pragma mark - ZHAudioMediaItemDelegate
- (void)audioMediaItem:(ZHCAudioMediaItem *)audioMediaItem
didChangeAudioCategory:(NSString *)category
               options:(AVAudioSessionCategoryOptions)options
                 error:(nullable NSError *)error{
    if (!error) {
        if (currentAudioItem && ![audioMediaItem isEqual:currentAudioItem]) {
            [currentAudioItem stopPlay];
        }
        currentAudioItem = audioMediaItem;
    }else{
        NSLog(@"Play Audio error:%@",error.localizedDescription);
    }
}


#pragma mark - ZHCMessagesMoreViewDataSource
-(NSArray *)messagesMoreViewTitles:(ZHCMessagesMoreView *)moreView
{
    return @[@"Video",@"Photos",@"Location"];
}

-(NSArray *)messagesMoreViewImgNames:(ZHCMessagesMoreView *)moreView
{
    return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location"];
}

-(void)addPhotoMediaMessage
{
    ZHCPhotoMediaItem *photoItem = [[ZHCPhotoMediaItem alloc]initWithImage:[UIImage imageNamed:@"itachi"]];
    photoItem.appliesMediaViewMaskAsOutgoing = NO;
    ZHCMessage *photoMessage = [ZHCMessage messageWithSenderId:kAvatarIdSender displayName:kAvatarDisplayNameSender media:photoItem];
    [self.messages addObject:photoMessage];
    
    
    /*------------Network Load Picture Demo----------------------------------*/
    /*NSString *imgUrl1 = @"https://dn-lk71houg.qbox.me/22b40068d8a338e1c513.jpg";
     NSString *imgUrl2 = @"https://dn-lk71houg.qbox.me/71ba042da28571aa6279.jpg";
     static BOOL chooseBool = NO;
     NSString *imgUrl = imgUrl1;
     if (!chooseBool) {
     imgUrl = imgUrl2;
     }
     chooseBool =!chooseBool;
     ZHPhotoItem  *photoItem = [[ZHPhotoItem alloc]initWithImgUrl:imgUrl withWidth:200 withHeight:200];
     photoItem.appliesMediaViewMaskAsOutgoing = NO;
     ZHCMessage *photoMessage = [ZHCMessage messageWithSenderId:kZHCDemoAvatarIdCook displayName:kZHCDemoAvatarDisplayNameCook media:photoItem];
     [self.messages addObject:photoMessage];*/
    /*------------Network Load Picture Demo----------------------------------*/
    
}

- (void)addLocationMediaMessageCompletion:(ZHCLocationMediaItemCompletionBlock)completion
{
    CLLocation *ferryBuildingInSF = [[CLLocation alloc] initWithLatitude:22.610599 longitude:114.030238];
    
    ZHCLocationMediaItem *locationItem = [[ZHCLocationMediaItem alloc] init];
    [locationItem setLocation:ferryBuildingInSF withCompletionHandler:completion];
    locationItem.appliesMediaViewMaskAsOutgoing = YES;
    
    ZHCMessage *locationMessage = [ZHCMessage messageWithSenderId:kAvatarIdSender
                                                      displayName:kAvatarDisplayNameSender
                                                            media:locationItem];
    [self.messages addObject:locationMessage];
}

- (void)addVideoMediaMessage
{
    // don't have a real video, just pretending
    NSURL *videoURL = [NSURL URLWithString:@"file://"];
    
    ZHCVideoMediaItem *videoItem = [[ZHCVideoMediaItem alloc] initWithFileURL:videoURL isReadyToPlay:YES];
    videoItem.appliesMediaViewMaskAsOutgoing = YES;
    ZHCMessage *videoMessage = [ZHCMessage messageWithSenderId:kAvatarIdSender
                                                   displayName:kAvatarDisplayNameSender
                                                         media:videoItem];
    [self.messages addObject:videoMessage];
}

- (void)addAudioMediaMessage
{
    NSString * sample = [[NSBundle mainBundle] pathForResource:@"zhc_messages_sample" ofType:@"m4a"];
    
    NSData * audioData = [NSData dataWithContentsOfFile:sample];
    ZHCAudioMediaItem *audioItem = [[ZHCAudioMediaItem alloc] initWithData:audioData];
    audioItem.appliesMediaViewMaskAsOutgoing = NO;
    ZHCMessage *audioMessage = [ZHCMessage messageWithSenderId:kAvatarIdSender
                                                   displayName:kAvatarDisplayNameSender
                                                         media:audioItem];
    [self.messages addObject:audioMessage];
}


#pragma mark - PrivateMethods
-(void)closePressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
