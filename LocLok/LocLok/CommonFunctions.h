//
//  CommonFunctions.h
//  LocShare
//
//  Created by yxiao on 8/9/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//

#import<UIKit/UIKit.h>
#import<MapKit/MapKit.h>
//#import "YXThumbnailAnnotation.h"
//#import "YXThumbnail.h"
//@class YXThumbnail;
#define ARC4RANDOM_MAX      0x100000000
@interface CommonFunctions : NSObject


+(BOOL)writeToPlist: (NSString *)fileName
:(NSArray*) objInfo
:(NSString *)objName;

+(NSDictionary*)retrieveFromPlist: (NSString *)fileName;
+(UIImage *) getImageFromURL:(NSString *)fileURL;
+(void) saveImage:(UIImage *)image
     withFileName:(NSString *)imageName
           ofType:(NSString *)extension
      inDirectory:(NSString *)directoryPath;
+(UIImage *) loadImage:(NSString *)fileName
                ofType:(NSString *)extension
           inDirectory:(NSString *)directoryPath;




+(void)saveImageFromURLToLocal:(NSString*)ImageURL
                              :(NSString*)user_id;
+(UIImage*)loadImageFromLocal:(NSString*)user_id;

//retrieve from plist the image URL of the user by id;
+(NSString*)retrieveImageInfoFromPlist:(NSString*)fileName
                            withUserId:(NSString*)id;

+(NSInteger)Weekday2Number:(NSString *)strWeekday;
+ (NSUInteger)indexofAnnotationInOverlays:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapoverlays;
//+ (NSUInteger)indexofAnnotation:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapannotations;
//+(PrivSetting*)initPrivSettingWithDefault;
double GenGammaRV(float radius);//radius is the expect radius chose by user;
double GenRandomU01();
double quantile_radius(int percentage,float R);
@end

