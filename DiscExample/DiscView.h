//
//  DiscView.h
//  DiscExample
//
//  Created by hwk on 13-11-27.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//typedef void(^Touch)();

@interface DiscView : UIView

@property (setter = setDR:, nonatomic)float drawRadian;
@property (assign, nonatomic)float edgeWidth;
@property (assign, nonatomic)float rotationSpeed;
@property (assign, nonatomic)BOOL isPlaying;
@property (strong, nonatomic)UIColor* strokeColor;
@property (copy, nonatomic)dispatch_block_t touch;

- (void)setDisc:(UIImage*)image radius:(float)radius edgeWidth:(float)ewidth;
- (void)setDrawRadius:(float)radius;

- (void)startAnimation;
- (void)stopAnimation;

@end
