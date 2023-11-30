#import "Douyin.h"
#import <DouyinOpenSDK/DouyinOpenSDKAuth.h>
#import<DouyinOpenSDK/DouyinOpenSDKApplicationDelegate.h>
#import <DouyinOpenSDK/DouyinOpenSDKShare.h>


@implementation Douyin

RCT_EXPORT_MODULE(DouYinModule)





RCT_EXPORT_METHOD(auth:(NSString *)scope
                  state:(NSString *)state
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
      DouyinOpenSDKAuthRequest *req = [[DouyinOpenSDKAuthRequest alloc] init];
      
      req.permissions = [NSOrderedSet orderedSetWithObject:scope];
     // req.state=state;
      
      UIViewController *vc =  [UIApplication sharedApplication].keyWindow.rootViewController;

     [req sendAuthRequestViewController:vc completeBlock:^(DouyinOpenSDKAuthResponse * _Nonnull resp) {
     if (resp.errCode == 0) {
               resolve(@{
                   @"authCode": resp.code
                       });
            } else{
                [NSString stringWithFormat:@"Author failed code : %@, msg : %@",@(resp.errCode), resp.errString];
                reject([NSString stringWithFormat:@"%@",@(resp.errCode)],resp.errString,nil);
            }
        }];
   
  });
}


RCT_EXPORT_METHOD(init:(NSString *)appid
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
     [[DouyinOpenSDKApplicationDelegate sharedInstance] registerAppId:appid];
  });
}
// 分享网页
RCT_EXPORT_METHOD(shareLink:(NSDictionary *)data resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DouyinOpenSDKShareRequest *req = [[DouyinOpenSDKShareRequest alloc] init];
        NSLog(@"Preparing to share link...");
        DouyinOpenSDKShareLink *link = [DouyinOpenSDKShareLink new];
        link.linkURLString = data[@"webpageUrl"];
        link.linkTitle = data[@"title"];
        link.linkDescription = data[@"description"];
        link.linkCoverURLString = data[@"thumbImageUrl"];
        
        req.shareLink = link;
        req.shareAction = DouyinOpenSDKShareTypeShareContentToIM;
        
   
        [req sendShareRequestWithCompleteBlock:^(DouyinOpenSDKShareResponse * _Nonnull respond) {
            NSString *alertString = nil;
            NSLog(@"Share response: %@", respond);
                NSLog(@"Share response errCode: %ld", (long)respond.errCode);
                NSLog(@"Share response errString: %@", respond.errString);
            if (respond.isSucceed) {
                NSLog(@"Share succeeded");
                resolve(@(YES));
            } else{
                NSLog(@"Share failed with error: %@", respond.errString);
                reject([NSString stringWithFormat:@"%@",@(respond.errCode)],respond.errString,nil);
                //  Share failed
            }
        }];
    });
}
@end
