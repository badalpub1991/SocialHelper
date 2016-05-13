# SocialHelper

Google -> http://stackoverflow.com/questions/34368613/custom-google-sign-in-button-ios // Custom button

Frameworks-> https://www.wetransfer.com/downloads/8a54259407d0d6f29c5ba4a3f889668220160512190124/304738422dd09651837e0e8512034b0120160512190124/c97c7d

#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
  
  ```
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager GET:frameurl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"the answer is %@",responseObject);
            
            Numberofframe=[[responseObject valueForKey:@"frame_categorys"]valueForKey:@"frame_image"];
            
            NSLog(@"Numberofframe %@",Numberofframe);
            
            aryFrameID  = [[responseObject objectForKey:@"frame_categorys"]valueForKey:@"frame_id"];
            aryLabel=[[responseObject objectForKey:@"frame_categorys"]valueForKey:@"frame_name"];
            [_framecollectionview reloadData];

              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",[error localizedDescription]);
        }];

        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [ABProgressPlus dismiss];

        });
    });
  ```
  
  ```
  
   [cell.imgviewFrame sd_setImageWithURL:[NSURL URLWithString:[Numberofframe objectAtIndex:indexPath.row]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [cell.indicatorView stopAnimating];
        cell.indicatorView.hidden = YES;

        cell.imgviewFrame.image = image;
    }];
  ```  
    
  Map.h
```  
  @interface PickUpVC : BaseVC<MKMapViewDelegate,CLLocationManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,GMSMapViewDelegate,UIAlertViewDelegate>
{
    NSTimer *timerForCheckReqStatus;
    CLLocationManager *locationManager;
    NSDictionary* aPlacemark;
    NSMutableArray *placeMarkArr;
}
- (IBAction)pickMeUpBtnPressed:(id)sender;
- (IBAction)cancelReqBtnPressed:(id)sender;
- (IBAction)myLocationPressed:(id)sender;
```
  map.m
#import <GoogleMaps/GoogleMaps.h>

viewdidload
```
 [self updateLocationManagerr];
        CLLocationCoordinate2D coordinate = [self getLocation];
        strForCurLatitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
        strForCurLongitude= [NSString stringWithFormat:@"%f", coordinate.longitude];
    
        strForLatitude=strForCurLatitude;
        strForLongitude=strForCurLongitude;
        [self getAddress];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[strForCurLatitude doubleValue] longitude:[strForCurLongitude doubleValue] zoom:14];
        mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.viewGoogleMap.frame.size.width, self.viewGoogleMap.frame.size.height) camera:camera];
        mapView_.myLocationEnabled = NO;
        mapView_.delegate=self;
        [self.viewGoogleMap addSubview:mapView_];
        [self.view bringSubviewToFront:self.tableForCity];
```

```
#pragma mark - Location Delegate

-(CLLocationCoordinate2D) getLocation
{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
        CLLocation *location = [locationManager location];
        CLLocationCoordinate2D coordinate = [location coordinate];
        return coordinate;
}

-(void)updateLocationManagerr
{
    [locationManager startUpdatingLocation];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
  

#ifdef __IPHONE_8_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
#endif
    
    [locationManager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    strForCurLatitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    strForCurLongitude=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
   // GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:newLocation.coordinate zoom:14];
    //[mapView_ animateWithCameraUpdate:updatedCamera];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
}


//

#pragma mark- Google Map Delegate

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    strForLatitude=[NSString stringWithFormat:@"%f",position.target.latitude];
    strForLongitude=[NSString stringWithFormat:@"%f",position.target.longitude];
}

- (void) mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    if (arrDriver.count>0)
    {
        [self getETA:[arrDriver objectAtIndex:0]];
    }
    [self getAddress];
    [self getProviders];
}

-(void)getAddress
{
    NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false",[strForLatitude floatValue], [strForLongitude floatValue], [strForLatitude floatValue], [strForLongitude floatValue]];
    
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [str dataUsingEncoding:NSUTF8StringEncoding]
                                                         options: NSJSONReadingMutableContainers
                                                           error: nil];
    
    NSDictionary *getRoutes = [JSON valueForKey:@"routes"];
    NSDictionary *getLegs = [getRoutes valueForKey:@"legs"];
    NSArray *getAddress = [getLegs valueForKey:@"end_address"];
    if (getAddress.count!=0)
    {
        self.txtAddress.text=[[getAddress objectAtIndex:0]objectAtIndex:0];
    }
}

//

#pragma mark - Mapview Delegate

-(void)showMapCurrentLocatinn
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
   
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:14];
    [mapView_ animateWithCameraUpdate:updatedCamera];

   [self getAddress];
    
}
```

