//
//  AdminChat.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <ZHChat/ZHCMessages.h>

static NSString * const kAvatarDisplayNameReciever = @"TMA Digital";
static NSString * const kAvatarDisplayNameSender = @"Phone";

static NSString * const kAvatarIdReciever = @"468-768355-23123";
static NSString * const kAvatarIdSender = @"707-8956784-57";

@interface AdminChat : ZHCMessagesViewController <ZHCAudioMediaItemDelegate>
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSDictionary *avatars;
@property (strong, nonatomic) NSDictionary *users;
@property (strong, nonatomic) ZHCMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) ZHCMessagesBubbleImage *incomingBubbleImageData;

- (void)addPhotoMediaMessage;
- (void)addLocationMediaMessageCompletion:(ZHCLocationMediaItemCompletionBlock)completion;
- (void)addVideoMediaMessage;
- (void)addAudioMediaMessage;
@end
