//
//  YXThumbnail.h
//  YXThumbnailAnnotation
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
//@import MapKit;
//#import <CoreLocation/CoreLocation.h>
typedef void (^ActionBlock)();

@interface YXThumbnail : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) ActionBlock disclosureBlock;

@end
