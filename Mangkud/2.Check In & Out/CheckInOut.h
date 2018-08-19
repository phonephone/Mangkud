//
//  CheckInOut.h
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CheckInOut : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>
{
    AppDelegate *delegate;
    NSMutableDictionary *clockJSON;
    
    CLLocationManager * locationManager;
    
    int syncCount;
    NSString *loadStatus; //get, not
    NSString *checkStatus; //in ,out
    NSString *clocktype; // 0 ,1 ,2
    
    CLLocationCoordinate2D userCoordinate;
    NSString *latitude;
    NSString *longitude;
    
    BOOL clockIN;
    BOOL clockOUT;
    NSString *inTime;
    NSString *outTime;
    BOOL timeSync;
    BOOL inLocation;
}

@property (weak, nonatomic) IBOutlet UIButton *checkInBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stampBtn;

@property (weak, nonatomic) IBOutlet MKMapView *myMap;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel2;
@end
