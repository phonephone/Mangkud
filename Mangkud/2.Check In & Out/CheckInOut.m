//
//  CheckInOut.m
//  Mangkud
//
//  Created by Firststep Consulting on 27/2/18.
//  Copyright © 2018 TMA Digital Company Limited. All rights reserved.
//

#import "CheckInOut.h"
#import "AdminChat.h"
#import "NHNetworkTime.h"
#import "AdminChatWeb.h"

@interface CheckInOut ()

@end

@implementation CheckInOut

@synthesize checkInBtn,checkOutBtn,timeLabel,stampBtn,warnLabel,warnLabel2,myMap;

- (void)viewWillAppear:(BOOL)animated
{
    self.menuContainerViewController.panMode = YES;
    self.tabBarController.tabBar.hidden = NO;

    clockIN = NO;
    clockOUT = NO;
    inLocation = NO;
    
    if(![[NHNetworkClock sharedNetworkClock]isSynchronized])
    {
        stampBtn.enabled = NO;
        [[NHNetworkClock sharedNetworkClock] synchronize];
        warnLabel.text = @"Synchronizing time...";
        warnLabel.textColor = [UIColor grayColor];
        syncCount = 0;
    }
    
    loadStatus = @"get";
    warnLabel2.text = @"Location tracking...";
    warnLabel2.textColor = [UIColor grayColor];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    inTime = @"-";
    outTime = @"-";
    checkStatus = @"in";
    
    myMap.delegate = self;
    
    [self showTime];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
    timeLabel.font = [UIFont fontWithName:delegate.fontMedium size:delegate.fontSize+80];
    stampBtn.titleLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+4];
    [stampBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
    warnLabel.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-1];
    warnLabel2.font = [UIFont fontWithName:delegate.fontRegular size:delegate.fontSize-2];
    
    /*decimal
     places   degrees          distance
     -------  -------          --------
     0        1                111.32  km
     1        0.1              11.132 km
     2        0.01             1.1132 km
     3        0.001            111.32  m
     4        0.0001           11.132 m
     5        0.00001          1.1132 m
     6        0.000001         11.132 cm
     7        0.0000001        1.1132 cm
     8        0.00000001       1.1132 mm
     9        0.000000001      111.32  μm
     10       0.0000000001     11.132 μm
     11       0.00000000001    1.1132 μm
     12       0.000000000001   111.32  nm
     13       0.0000000000001  11.132 nm
     */
}

-(void)showTime{
    syncCount++;
    
    if  ([checkStatus isEqualToString:@"in"]) {
        [self checkInClicked:nil];
    }
    else if ([checkStatus isEqualToString:@"out"]) {
        [self checkOutClicked:nil];
    }
}

- (IBAction)checkInClicked:(id)sender
{
    checkStatus = @"in";
    [checkInBtn setImage:[UIImage imageNamed:@"Check_in_on"] forState:UIControlStateNormal];
    [checkOutBtn setImage:[UIImage imageNamed:@"Check_out_off"] forState:UIControlStateNormal];
    [stampBtn setTitle:@"เข้างาน" forState:UIControlStateNormal];
    
    if (clockIN == YES && timeSync == YES && inLocation == YES) {
        stampBtn.enabled = YES;
        [stampBtn setBackgroundImage:[UIImage imageNamed:@"btn_green"] forState:UIControlStateNormal];
    }
    else {
        stampBtn.enabled = NO;
        [stampBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    }
    [self updateTime];
}

- (IBAction)checkOutClicked:(id)sender
{
    checkStatus = @"out";
    [checkInBtn setImage:[UIImage imageNamed:@"Check_in_off"] forState:UIControlStateNormal];
    [checkOutBtn setImage:[UIImage imageNamed:@"Check_out_on"] forState:UIControlStateNormal];
    [stampBtn setTitle:@"ออกงาน" forState:UIControlStateNormal];
    
    stampBtn.enabled = clockOUT;
    if (clockOUT == YES && timeSync == YES && inLocation == YES) {
        stampBtn.enabled = YES;
        [stampBtn setBackgroundImage:[UIImage imageNamed:@"btn_red"] forState:UIControlStateNormal];
    }
    else {
        stampBtn.enabled = NO;
        [stampBtn setBackgroundImage:[UIImage imageNamed:@"btn_gray"] forState:UIControlStateNormal];
    }
    [self updateTime];
}

- (void)updateTime
{
    if(![[NHNetworkClock sharedNetworkClock]isSynchronized])
    {
        if(syncCount >= 8)
        {
            timeSync = NO;
            warnLabel.text = @"Time Sync Error";
            warnLabel.textColor = [UIColor colorWithRed:225.0/255 green:66.0/255 blue:44.0/255 alpha:1];
        }
    }
    else
    {
        timeSync = YES;
        warnLabel.text = @"Time Synced";
        warnLabel.textColor = [UIColor colorWithRed:61.0/255 green:134.0/255 blue:66.0/255 alpha:1];
    }
    
    
    if  ([checkStatus isEqualToString:@"in"]&&![inTime isEqualToString:@"-"])
    {
        timeLabel.text = inTime;
        timeLabel.textColor = [UIColor colorWithRed:61.0/255 green:134.0/255 blue:66.0/255 alpha:1];
        warnLabel.text = @"เข้างานเมื่อเวลา";
        warnLabel.textColor = [UIColor colorWithRed:61.0/255 green:134.0/255 blue:66.0/255 alpha:1];
    }
    else if ([checkStatus isEqualToString:@"out"]&&![outTime isEqualToString:@"-"])
    {
        timeLabel.text = outTime;
        timeLabel.textColor = [UIColor colorWithRed:225.0/255 green:66.0/255 blue:44.0/255 alpha:1];
        warnLabel.text = @"ออกจากงานเมื่อเวลา";
        warnLabel.textColor = [UIColor colorWithRed:225.0/255 green:66.0/255 blue:44.0/255 alpha:1];
    }
    else{
        //NSLog(@"XXXXXXX %d",[[NHNetworkClock sharedNetworkClock]isSynchronized]);
        NSDate *currDate = [NSDate networkDate];//[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"HH : mm"];//@"dd.MM.YY HH:mm:ss"
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        timeLabel.text = dateString;
        timeLabel.textColor = [UIColor colorWithRed:148.0/255 green:149.0/255 blue:153.0/255 alpha:1];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    else if (status == kCLAuthorizationStatusDenied) {
        // The user denied authorization
        NSLog(@"Denied");
        [self locationService];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // The user accepted authorization
        NSLog(@"Allow");
        [self locationService];
    }
}

- (void)locationService
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location Services was disable" message:@"อนุญาตให้แอพเข้าถึงตำแหน่งปัจจุบันของคุณเพื่อใช้งานฟังก์ชั่นนี้" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        //TODO if user has not given permission to device
                                        if (![CLLocationManager locationServicesEnabled])
                                        {
                                            CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
                                            if (systemVersion < 10) {
                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"]];
                                            }else{
                                                if (@available(iOS 10.0, *)) {
                                                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"App-Prefs:root=Privacy&path=LOCATION"]
                                                                                      options:[NSDictionary dictionary]
                                                                            completionHandler:nil];
                                                } else {
                                                    // Fallback on earlier versions
                                                }
                                            }
                                        }
                                        //TODO if user has not given permission to particular app
                                        else
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                        }
                                    }];
    [alertController addAction:settingAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Canelled");
        [self locationService];
    }];
    [alertController addAction:cancelAction];
    
    if(![CLLocationManager locationServicesEnabled]){
        //ปิด Location Service
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
        //ปิด Location Service เฉพาะแอพ
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        //เปิด Location Service
        
        userCoordinate = [self getLocation];
        latitude = [NSString stringWithFormat:@"%f", userCoordinate.latitude];
        longitude = [NSString stringWithFormat:@"%f", userCoordinate.longitude];
        
        NSLog(@"lat = %@",latitude);
        NSLog(@"long = %@",longitude);
        
        //delegate.latitude = @"13.7370";
        //delegate.longitude = @"100.5604";
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userCoordinate, 300, 300);
        MKCoordinateRegion adjustedRegion = [myMap regionThatFits:viewRegion];
        [myMap setRegion:adjustedRegion animated:YES];
        
        [self stampClicked:nil];
    }
}

-(CLLocationCoordinate2D) getLocation{
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [locationManager stopUpdatingLocation];
    return coordinate;
}

- (IBAction)stampClicked:(id)sender
{
    NSDate *currDate = [NSDate networkDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"th"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd/MM/YY"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *timeString = [dateFormatter stringFromDate:currDate];
    
    NSString *title;
    NSString *message;
    
    if  ([checkStatus isEqualToString:@"in"]) {
        clocktype = @"1";
        title = [NSString stringWithFormat:@"บันทึกการเข้างาน"];
        message = [NSString stringWithFormat:@"\nวันที่ %@\nเข้างานเวลา %@",dateString,timeString];
    }
    else if ([checkStatus isEqualToString:@"out"]) {
        clocktype = @"2";
        title = [NSString stringWithFormat:@"บันทึกการออกงาน"];
        message = [NSString stringWithFormat:@"\nวันที่ %@\nออกงานเวลา %@",dateString,timeString];
    }
    
    [SVProgressHUD showWithStatus:@"Loading"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    NSString *clockDate = [dateFormatter stringFromDate:currDate];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *clockTime = [dateFormatter stringFromDate:currDate];
    
    NSString* url;
    if  ([loadStatus isEqualToString:@"get"]) {
        url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/%@",HOST_DOMAIN,delegate.userID,clockDate];
        //url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/15-05-2018",HOST_DOMAIN,delegate.userID];
    }
    else {
        url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/%@/%@/%@/%@/%@",HOST_DOMAIN,delegate.userID,clockDate,clockTime,clocktype,latitude,longitude];
        //url = [NSString stringWithFormat:@"%@clockInClockOutData/%@/15-05-2018/%@/%@",HOST_DOMAIN,delegate.userID,clockTime,clocktype];
        //http://mangkud.co/index.php?MobileApi/clockInClockOutData/14/25-03-2018/09:08/1
    }
    //NSLog(@"URL = %@",url);
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"ClockJSON %@",responseObject);
         if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
             clockJSON = [[responseObject objectForKey:@"data"] objectAtIndex:0];
            
             clockIN = [[clockJSON objectForKey:@"clock_in_btn"] boolValue];
             clockOUT = [[clockJSON objectForKey:@"clock_out_btn"] boolValue];
             inTime = [NSString stringWithFormat:@"%@",[clockJSON objectForKey:@"clock_in_time"]];
             outTime = [NSString stringWithFormat:@"%@",[clockJSON objectForKey:@"clock_out_time"]];
             
             /*
             clockIN = YES;
             clockOUT = NO;
             inTime = @"-";
             outTime = @"17:00";
             */
             
             if  ([loadStatus isEqualToString:@"get"]) {
                 [self compareLocation];
             }
             else {
                 [self alertTitle:title alertDetail:message];
             }
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

- (void)compareLocation
{
    /*
    NSLog(@"IN = %d",[[clockJSON objectForKey:@"clock_in_btn"] boolValue]);
    NSLog(@"OUT = %d",[[clockJSON objectForKey:@"clock_out_btn"] boolValue]);
    NSLog(@"IN Time = %@",[clockJSON objectForKey:@"clock_in_time"]);
    NSLog(@"OUT Time = %@",[clockJSON objectForKey:@"clock_out_time"]);
    NSLog(@"Location X = %@",[[[clockJSON objectForKey:@"location"] objectAtIndex:0] objectForKey:@"lat"]);
    NSLog(@"Location Y = %@",[[[clockJSON objectForKey:@"location"] objectAtIndex:0] objectForKey:@"lng"]);
    */
    [myMap removeOverlays:myMap.overlays];
    
    float userLat = userCoordinate.latitude;
    float userLong = userCoordinate.longitude;
    float distance = [[clockJSON objectForKey:@"distance"] floatValue];
    BOOL nearFound = NO;
    
    if ([[clockJSON objectForKey:@"distance"] isEqualToString:@"0"]) {
        nearFound = YES;
    }
    else{
        for (int i=0; i<[[clockJSON objectForKey:@"location"] count]; i++)
        {
            
            
            float checkLat = [[[[clockJSON objectForKey:@"location"] objectAtIndex:i] objectForKey:@"lat"] floatValue];
            float checkLong = [[[[clockJSON objectForKey:@"location"] objectAtIndex:i] objectForKey:@"lng"] floatValue];
            //float checkLat = 13.859815;
            //float checkLong = 100.664640;
            
            CLLocationDistance fenceDistance = distance*100000;
            CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(checkLat, checkLong);
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
            [myMap addOverlay: circle];
            
            float diffLat = ABS(userLat-checkLat);
            float diffLong = ABS(userLong-checkLong);
            
            NSLog(@"XXXXXXXXXXXX %f - %f = %f",userLat,checkLat,diffLat);
            NSLog(@"YYYYYYYYYYYY %f - %f = %f",userLong,checkLong,diffLong);
            
            if (diffLat < distance && diffLong < distance) {
                nearFound = YES;
            }
        }
    }
    
    if (nearFound == YES) {
        inLocation = YES;
        warnLabel2.text = @"อยู่บริเวณที่ทำงาน";
        warnLabel2.textColor = [UIColor colorWithRed:61.0/255 green:134.0/255 blue:66.0/255 alpha:1];
    }
    else
    {
        inLocation = NO;
        warnLabel2.text = @"ไม่อยู่ในบริเวณที่ทำงาน";
        warnLabel2.textColor = [UIColor colorWithRed:225.0/255 green:66.0/255 blue:44.0/255 alpha:1];
    }
    
    loadStatus = @"not";
    
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circleR.fillColor = [UIColor colorWithRed:115.0/255 green:188.0/255 blue:66.0/255 alpha:0.5];
    
    return circleR;
}

- (IBAction)showLeftMenuPressed:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)rightMenu:(id)sender {
    AdminChatWeb *viewController = [[AdminChatWeb alloc]initWithNibName:@"AdminChatWeb" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)alertTitle:(NSString*)title alertDetail:(NSString*)detail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *titleFont = [[NSMutableAttributedString alloc] initWithString:title];
    NSMutableAttributedString *messageFont = [[NSMutableAttributedString alloc] initWithString:detail];
    [titleFont addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:delegate.fontRegular size:delegate.fontSize+1]
                      range:NSMakeRange (0, titleFont.length)];
    [messageFont addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:delegate.fontLight size:delegate.fontSize-2]
                        range:NSMakeRange(0, messageFont.length)];
    [alertController setValue:titleFont forKey:@"attributedTitle"];
    [alertController setValue:messageFont forKey:@"attributedMessage"];
    
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
