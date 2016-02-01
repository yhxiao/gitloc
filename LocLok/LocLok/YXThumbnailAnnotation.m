//
//  YXThumbnailAnnotation.m
//  YXThumbnailAnnotationView
//
//

#import "YXThumbnailAnnotation.h"

@interface YXThumbnailAnnotation ()



@end


@implementation YXThumbnailAnnotation

@synthesize thumbnail,view,coordinate;
+ (instancetype)annotationWithThumbnail:(YXThumbnail *)thumbnail {
    return [[self alloc] initWithThumbnail:thumbnail];
}

- (id)initWithThumbnail:(YXThumbnail *)thumbnail2 {
    self = [super init];
    if (self) {
        coordinate = thumbnail2.coordinate;
        thumbnail = thumbnail2;
    }
    return self;
}

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!self.view) {
        self.view = (YXThumbnailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kYXThumbnailAnnotationViewReuseID];
        if (!self.view) self.view = [[YXThumbnailAnnotationView alloc] initWithAnnotation:self];
    } else {
        self.view.annotation = self;
    }
    [self updateThumbnail:self.thumbnail animated:NO];
    return self.view;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    coordinate=newCoordinate;
}
- (void)updateThumbnail:(YXThumbnail *)thumbnail2 animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
            coordinate = thumbnail2.coordinate; // use ivar to avoid triggering setter
        }];
    } else {
        coordinate = thumbnail2.coordinate; // use ivar to avoid triggering setter
    }
    
    [self.view updateWithThumbnail:thumbnail];
}

@end
