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
