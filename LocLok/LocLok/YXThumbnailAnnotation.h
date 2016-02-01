//
//  YXThumbnailAnnotation.h
//  YXThumbnailAnnotationView
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "YXThumbnail.h"
#import "YXThumbnailAnnotationView.h"

@protocol YXThumbnailAnnotationProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface YXThumbnailAnnotation : NSObject <MKAnnotation, YXThumbnailAnnotationProtocol>
@property (nonatomic, readwrite) YXThumbnailAnnotationView *view;
@property (nonatomic, readwrite) YXThumbnail *thumbnail;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

+ (instancetype)annotationWithThumbnail:(YXThumbnail *)thumbnail;
- (id)initWithThumbnail:(YXThumbnail *)thumbnail;
- (void)updateThumbnail:(YXThumbnail *)thumbnail animated:(BOOL)animated;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;//automatically sends KVO notifications;
@end
