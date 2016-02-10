//
//  YXThumbnailAnnotationView.m
//  YXThumbnailAnnotationView
//
//

#import <QuartzCore/QuartzCore.h>
#import "YXThumbnailAnnotationView.h"
#import "YXThumbnail.h"

NSString * const kYXThumbnailAnnotationViewReuseID = @"YXThumbnailAnnotationView";

static CGFloat const kYXThumbnailAnnotationViewStandardWidth     = 75.0f;
static CGFloat const kYXThumbnailAnnotationViewStandardHeight    = 87.0f;
static CGFloat const kYXThumbnailAnnotationViewExpandOffset      = 200.0f;
static CGFloat const kYXThumbnailAnnotationViewVerticalOffset    = 34.0f;
static CGFloat const kYXThumbnailAnnotationViewAnimationDuration = 0.15f;

@interface YXThumbnailAnnotationView ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) ActionBlock disclosureBlock;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *disclosureButton;
@property (nonatomic, assign) YXThumbnailAnnotationViewState state;

@end

@implementation YXThumbnailAnnotationView

#pragma mark - Setup

- (id)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [super initWithAnnotation:annotation reuseIdentifier:kYXThumbnailAnnotationViewReuseID];
    
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, kYXThumbnailAnnotationViewStandardWidth, kYXThumbnailAnnotationViewStandardHeight);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kYXThumbnailAnnotationViewVerticalOffset);
        
        _state = YXThumbnailAnnotationViewStateCollapsed;
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    [self setupImageView];
    [self setupTitleLabel];
    [self setupSubtitleLabel];
    [self setupDisclosureButton];
    [self setLayerProperties];
    [self setDetailGroupAlpha:0.0f];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5f, 12.5f, 50.0f, 47.0f)];
    _imageView.layer.cornerRadius = 4.0f;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.borderWidth = 0.5f;
    [self addSubview:_imageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32.0f, 16.0f, 168.0f, 20.0f)];
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.minimumScaleFactor = 0.8f;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
}

- (void)setupSubtitleLabel {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32.0f, 36.0f, 168.0f, 20.0f)];
    _subtitleLabel.textColor = [UIColor darkGrayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_subtitleLabel];
}

- (void)setupDisclosureButton {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f;
    UIButtonType buttonType = iOS7 ? UIButtonTypeSystem : UIButtonTypeCustom;
    _disclosureButton = [UIButton buttonWithType:buttonType];
    _disclosureButton.tintColor = [UIColor grayColor];
    UIImage *disclosureIndicatorImage = [YXThumbnailAnnotationView disclosureButtonImage];
    [_disclosureButton setImage:disclosureIndicatorImage forState:UIControlStateNormal];
    _disclosureButton.frame = CGRectMake(kYXThumbnailAnnotationViewExpandOffset/2.0f + self.frame.size.width/2.0f + 8.0f,
                                         26.5f,
                                         disclosureIndicatorImage.size.width,
                                         disclosureIndicatorImage.size.height);
    
    [_disclosureButton addTarget:self action:@selector(didTapDisclosureButton) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_disclosureButton];
}

- (void)setLayerProperties {
    _bgLayer = [CAShapeLayer layer];
    CGPathRef path = [self newBubbleWithRect:self.bounds];
    _bgLayer.path = path;
    CFRelease(path);
    _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    _bgLayer.shadowColor = [UIColor blackColor].CGColor;
    _bgLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    _bgLayer.shadowRadius = 2.0f;
    _bgLayer.shadowOpacity = 0.5f;
    
    _bgLayer.masksToBounds = NO;
    
    [self.layer insertSublayer:_bgLayer atIndex:0];
}

#pragma mark - Updating

- (void)updateWithThumbnail:(YXThumbnail *)thumbnail {
    self.coordinate = thumbnail.coordinate;
    self.titleLabel.text = thumbnail.title;
    self.subtitleLabel.text = thumbnail.subtitle;
    self.imageView.image = thumbnail.image;
    self.disclosureBlock = thumbnail.disclosureBlock;
}


- (NSUInteger)indexofAnnotationInOverlays:(NSString*)name at:(CLLocationCoordinate2D)pos in:(NSArray*)mapoverlays{
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

#pragma mark - YXThumbnailAnnotationViewProtocol

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView {
    // Center map at annotation point
    [mapView setCenterCoordinate:self.coordinate animated:YES];
    
    //NSLog(@"%@",mapView.annotations);
    //NSLog(@"%@",mapView.overlays);
    //NSLog(@"%lu",(unsigned long)[mapView.annotations indexOfObject:self.annotation]);
    MKCircleRenderer *circleView =(MKCircleRenderer*)[mapView rendererForOverlay:[mapView.overlays objectAtIndex:
                                                                                  [self indexofAnnotationInOverlays:self.titleLabel.text at:self.coordinate in:mapView.overlays]
    ]];
    circleView.strokeColor = [UIColor redColor];
    //circleView.alpha=0.1;
    circleView.fillColor=[UIColor redColor];
    //circleView.lineWidth=2.0;
    [circleView invalidatePath];
    
    [self expand];
    //[_imageView setTintColor:[UIColor redColor]];
    
    /*
    //Create animation
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillColorAnimation.duration = 1.5f;
    fillColorAnimation.fromValue = (id)[[UIColor whiteColor] CGColor];
    fillColorAnimation.toValue = (id)[[UIColor colorWithRed:0.5 green:0 blue:0 alpha:1] CGColor];
    fillColorAnimation.repeatCount = 10;
    fillColorAnimation.autoreverses = YES;
    [_bgLayer addAnimation:fillColorAnimation forKey:@"fillColor"];
     */
    
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView {
    [self shrink];
    //[_imageView setTintColor:nil];
    [_bgLayer removeAllAnimations];
    _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    //MKCircleRenderer *circleView =[mapView rendererForOverlay:[mapView.overlays objectAtIndex:[mapView.annotations indexOfObject:self.annotation]]];
    MKCircleRenderer *circleView =(MKCircleRenderer*)[mapView rendererForOverlay:[mapView.overlays objectAtIndex:
                                                                                  [self indexofAnnotationInOverlays:self.titleLabel.text at:self.coordinate in:mapView.overlays]
    ]];
    circleView.strokeColor = [UIColor blueColor];
    //circleView.alpha=0.1;
    circleView.fillColor=[UIColor blueColor];
    //circleView.lineWidth=2.0;
    [circleView invalidatePath];
    
    
    
}

#pragma mark - Geometry

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0f;
	CGFloat radius = 7.0f;
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat parentX = rect.origin.x + rect.size.width/2.0f;
	
	// Determine Size
	rect.size.width -= stroke + 14.0f;
	rect.size.height -= stroke + 29.0f;
	rect.origin.x += stroke / 2.0f + 7.0f;
	rect.origin.y += stroke / 2.0f + 7.0f;
    
	// Create Callout Bubble Path
	CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
	CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
	CGPathAddLineToPoint(path, NULL, parentX - 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14.0f);
	CGPathAddLineToPoint(path, NULL, parentX + 14.0f, rect.origin.y + rect.size.height);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
	CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
	CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
	CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
	CGPathCloseSubpath(path);
    return path;
}

#pragma mark - Animations

- (void)setDetailGroupAlpha:(CGFloat)alpha {
    self.disclosureButton.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.subtitleLabel.alpha = alpha;
}

- (void)expand {
    if (self.state != YXThumbnailAnnotationViewStateCollapsed) return;
    
    self.state = YXThumbnailAnnotationViewStateAnimating;
    
    [self animateBubbleWithDirection:YXThumbnailAnnotationViewAnimationDirectionGrow];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+kYXThumbnailAnnotationViewExpandOffset, self.frame.size.height);
    self.centerOffset = CGPointMake(kYXThumbnailAnnotationViewExpandOffset/2.0f, -kYXThumbnailAnnotationViewVerticalOffset);
    [UIView animateWithDuration:kYXThumbnailAnnotationViewAnimationDuration/2.0f delay:kYXThumbnailAnnotationViewAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setDetailGroupAlpha:1.0f];
    } completion:^(BOOL finished) {
        self.state = YXThumbnailAnnotationViewStateExpanded;
    }];
}

- (void)shrink {
    if (self.state != YXThumbnailAnnotationViewStateExpanded) return;
    
    self.state = YXThumbnailAnnotationViewStateAnimating;

    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width - kYXThumbnailAnnotationViewExpandOffset,
                            self.frame.size.height);
    
    [UIView animateWithDuration:kYXThumbnailAnnotationViewAnimationDuration/2.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setDetailGroupAlpha:0.0f];
                     }
                     completion:^(BOOL finished) {
                         [self animateBubbleWithDirection:YXThumbnailAnnotationViewAnimationDirectionShrink];
                         self.centerOffset = CGPointMake(0.0f, -kYXThumbnailAnnotationViewVerticalOffset);
                     }];
}

- (void)animateBubbleWithDirection:(YXThumbnailAnnotationViewAnimationDirection)animationDirection {
    BOOL growing = (animationDirection == YXThumbnailAnnotationViewAnimationDirectionGrow);
    // Image
    [UIView animateWithDuration:kYXThumbnailAnnotationViewAnimationDuration animations:^{
        CGFloat xOffset = (growing ? -1 : 1) * kYXThumbnailAnnotationViewExpandOffset/2.0f;
        self.imageView.frame = CGRectOffset(self.imageView.frame, xOffset, 0.0f);
    } completion:^(BOOL finished) {
        if (animationDirection == YXThumbnailAnnotationViewAnimationDirectionShrink) {
            self.state = YXThumbnailAnnotationViewStateCollapsed;
        }
    }];
    
    // Bubble
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = kYXThumbnailAnnotationViewAnimationDuration;
    
    // Stroke & Shadow From/To Values
    CGRect largeRect = CGRectInset(self.bounds, -kYXThumbnailAnnotationViewExpandOffset/2.0f, 0.0f);
    
    CGPathRef fromPath = [self newBubbleWithRect:growing ? self.bounds : largeRect];
    animation.fromValue = (__bridge id)fromPath;
    CGPathRelease(fromPath);
    
    CGPathRef toPath = [self newBubbleWithRect:growing ? largeRect : self.bounds];
    animation.toValue = (__bridge id)toPath;
    CGPathRelease(toPath);
    
    [self.bgLayer addAnimation:animation forKey:animation.keyPath];
}

#pragma mark - Disclosure Button

- (void)didTapDisclosureButton {
    if (self.disclosureBlock) self.disclosureBlock();
}

+ (UIImage *)disclosureButtonImage {
    CGSize size = CGSizeMake(21.0f, 36.0f);
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(2.0f, 2.0f)];
    [bezierPath addLineToPoint:CGPointMake(10.0f, 10.0f)];
    [bezierPath addLineToPoint:CGPointMake(2.0f, 18.0f)];
    [[UIColor lightGrayColor] setStroke];
    bezierPath.lineWidth = 3.0f;
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
