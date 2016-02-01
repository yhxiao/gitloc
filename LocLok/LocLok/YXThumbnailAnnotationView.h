//
//  YXThumbnailAnnotationView.h
//  YXThumbnailAnnotationView
//
//

#import <MapKit/MapKit.h>

@class YXThumbnail;

extern NSString * const kYXThumbnailAnnotationViewReuseID;

typedef NS_ENUM(NSInteger, YXThumbnailAnnotationViewAnimationDirection) {
    YXThumbnailAnnotationViewAnimationDirectionGrow,
    YXThumbnailAnnotationViewAnimationDirectionShrink,
};

typedef NS_ENUM(NSInteger, YXThumbnailAnnotationViewState) {
    YXThumbnailAnnotationViewStateCollapsed,
    YXThumbnailAnnotationViewStateExpanded,
    YXThumbnailAnnotationViewStateAnimating,
};

@protocol YXThumbnailAnnotationViewProtocol <NSObject>

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView;
- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView;

@end

@interface YXThumbnailAnnotationView : MKAnnotationView <YXThumbnailAnnotationViewProtocol>

- (id)initWithAnnotation:(id<MKAnnotation>)annotation;

- (void)updateWithThumbnail:(YXThumbnail *)thumbnail;

// Programmatically expand the annotation
- (void)expand;

// Programmatically shrink the annotation
- (void)shrink;

@end
