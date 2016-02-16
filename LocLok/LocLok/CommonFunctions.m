//
//  CommonFunctions.m
//  LocShare
//
//  Created by yxiao on 8/9/15.
//  Copyright (c) 2015 Yonghui Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonFunctions.h"

double  quantile_gramma2[7]={1.0973,
        1.3763,
        1.6782,
        2.0222,
        2.4390,
        2.9940,
        3.8900};

extern NSString* LocalImagePlist;
@implementation CommonFunctions

+(BOOL)writeToPlist: (NSString *)fileName
                   : (NSArray*) objInfo
                   :(NSString *)objName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:fileName];


    // create dictionary with values in UITextFields
    NSDictionary *plistDict = [NSDictionary
                               dictionaryWithObject:objInfo
                               forKey:objName
                               ];

    NSError *error = [NSError alloc];
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0
                                                                    error:&error
                         ];
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        return NO;
    }
    return YES;
}

+(NSDictionary*)retrieveFromPlist: (NSString *)fileName{
    /*retrieve userInfo from plist;*/
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	// get documents path
	NSString *documentsPath = [paths objectAtIndex:0];
	// get the path to our Data/plist file
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:fileName];

	// check to see if Data.plist exists in documents
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
	{
		// if not in documents, get property list from main bundle
		plistPath = [[NSBundle mainBundle] pathForResource:[fileName substringToIndex:[fileName length]-6]
                                                    ofType:@"plist"];
        //NSLog(@"BasicData does not exist");
	}

	// read property list into memory as an NSData object
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSError *errorDesc =[NSError alloc];
	NSPropertyListFormat format;
	// convert static property list into dictionary object
	NSDictionary* temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}

    return temp;

}




+(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
+(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
    
}
+(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}


+(void)saveImageFromURLToLocal:(NSString*)ImageURL
                              :(NSString*)user_id{
    
    //save the image to local directory
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //Get Image From URL
    //NSLog(@"%@",profilePictureURL);
    UIImage * imageFromURL = [self getImageFromURL:ImageURL];
    
    //Load Image From Directory
    //UIImage* Profileimage = [self loadImage:[[KCSUser activeUser] username] ofType:@"png" inDirectory:documentsDirectoryPath];
    //if(Profileimage==nil){//MyProfilePicture.jpg does not exist, then save it;
        
        //Save Image to Directory
        [self saveImage:imageFromURL withFileName:user_id ofType:@"png" inDirectory:documentsDirectoryPath
         ];
    //}
    
    
}


+(UIImage*)loadImageFromLocal:(NSString*)user_id{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UIImage* image = [self loadImage:user_id ofType:@"png" inDirectory:documentsDirectoryPath];
    
    
    return image;
}


+(NSString*)retrieveImageInfoFromPlist:(NSString*)fileName
                            withUserId:(NSString*)id{
    NSDictionary *temp = [CommonFunctions retrieveFromPlist:LocalImagePlist];
    return [[temp objectForKey:id] objectAtIndex:0];
    
}

double GenGammaRV(float radius){//in km; radius is the expect radius chose by user;
    //    typedef std::mt19937 G;
    //    typedef std::gamma_distribution<> D;
    //    G g;  // seed if you want with integral argument
    //    double k = 2;      // http://en.wikipedia.org/wiki/Gamma_distribution
    //    double theta = 2.0;
    //    D d(k, theta);
    //    //std::cout << d(g) << '\n';
    //    return d(g);
    
    
    //        double d=2-1/3, c=1/sqrt(9*radius); bool flag=true;
    //        double Z,x,U,V;
    //        while(flag){
    //            Z=randn;//Z~Normal(0,1);
    //            if (Z>-1/c){
    //                V=(1+c*Z)^3; U=rand;
    //                flag=log(U)>(0.5*Z^2+d-d*V+d*log(V));
    //            }
    //        }
    //        x=d*V/lambda;
    //
    //        x=x*rand^(1/alpha);
    //
    //std::default_random_engine generator;
    //std::gamma_distribution<double> distribution(2.0,2.0);
    //return distribution(generator);
    
    
    double a1= ((double)arc4random() / ARC4RANDOM_MAX),a2=((double)arc4random() / ARC4RANDOM_MAX);
    return (-log(a1)-log(a2))*radius/2;
}
double GenGammaRV99(float radius){//in km; shape is circle containing 99% probability mass;
    //truncated geo-indistinguishability;
    double a1= ((double)arc4random() / ARC4RANDOM_MAX),a2=((double)arc4random() / ARC4RANDOM_MAX);
    //double v=(-log(a1)-log(a2))*radius/6.63835;//this means eps=6.6/r;
    double v=-log(a1)-log(a2);//this means eps=1;
    while(v>6.63835){//99% CDF
        a1= ((double)arc4random() / ARC4RANDOM_MAX),a2=((double)arc4random() / ARC4RANDOM_MAX);
        v=(-log(a1)-log(a2));
    }
    v=radius*v/6.3835;
    return v;
}
double GenGammaRV59(float radius){//in km; shape is circle containing 59% probability mass; center/edge=1/e;
    //truncated geo-indistinguishability;
    double a1= ((double)arc4random() / ARC4RANDOM_MAX),a2=((double)arc4random() / ARC4RANDOM_MAX);
    //double v=(-log(a1)-log(a2))*radius/6.63835;//this means eps=6.6/r;
    double v=-log(a1)-log(a2);//this means eps=1;
    while(v>2){//99% CDF
        a1= ((double)arc4random() / ARC4RANDOM_MAX),a2=((double)arc4random() / ARC4RANDOM_MAX);
        v=(-log(a1)-log(a2));
    }
    v=radius*v/2;
    return v;
}
double GenRandomU01(){
    return  ((double)arc4random() / ARC4RANDOM_MAX);
}

double quantile_radius(int percentage,float R){//
    switch (percentage) {
        case 30:
            return quantile_gramma2[0]/2*R;
            break;
        case 40:
            return quantile_gramma2[1]/2*R;
            break;
        case 50:
            return quantile_gramma2[2]/2*R;
            break;
        case 60:
            return quantile_gramma2[3]/2*R;
            break;
        case 70:
            return quantile_gramma2[4]/2*R;
            break;
        case 80:
            return quantile_gramma2[5]/2*R;
            break;
        case 90:
            return quantile_gramma2[6]/2*R;
            break;
            
        default:
            break;
    }
    return 0;
}

+(NSInteger)Weekday2Number:(NSString *)strWeekday{
    if([strWeekday isEqualToString:@"Sunday"]){
        return 0;
    }
    if([strWeekday isEqualToString:@"Monday"]){
        return 1;
    }
    if([strWeekday isEqualToString:@"Tuesday"]){
        return 2;
    }
    if([strWeekday isEqualToString:@"Wednesday"]){
        return 3;
    }
    if([strWeekday isEqualToString:@"Thursday"]){
        return 4;
    }
    if([strWeekday isEqualToString:@"Friday"]){
        return 5;
    }
    if([strWeekday isEqualToString:@"Saturday"]){
        return 6;
    }
    return -1;
}
+ (NSUInteger)indexofAnnotationInOverlays:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapoverlays{
    //NSUInteger j=0;
    for(NSUInteger i=0;i<mapoverlays.count;i++){
        //NSLog(@"%@, %@",name,[[mapoverlays objectAtIndex:i] title] );
        id<MKOverlay> ithOverlay=[mapoverlays objectAtIndex:i];
        if([name isEqualToString:ithOverlay.title] && pos.longitude==ithOverlay.coordinate.longitude && pos.latitude==ithOverlay.coordinate.latitude){
            
            return i;
        }
    }
    
    return 0;
}
//+ (NSUInteger)indexofAnnotation:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapannotations{
//
//    for(NSUInteger i=0;i<mapannotations.count;i++){
//        //NSLog(@"%@, %@",name,[[mapoverlays objectAtIndex:i] title] );
//        if([[mapannotations objectAtIndex:i] isKindOfClass:[YXThumbnailAnnotation class]]){
//            YXThumbnailAnnotation* ithAnnotation=(YXThumbnailAnnotation*) [mapannotations objectAtIndex:i];
//        if([name isEqualToString:ithAnnotation.thumbnail.title] && pos.longitude==ithAnnotation.coordinate.longitude && pos.latitude==ithAnnotation.coordinate.latitude){
//            
//            return i;
//        }
//        }
//    }
//    
//    return 0;
//}

@end