//
//  DiscView.m
//  DiscExample
//
//  Created by hwk on 13-11-27.
//
//

#import "DiscView.h"
#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

@interface DiscView(){
    //扇形参数
    double drawRadius;//半径
    int startX;//圆心x坐标
    int startY;//圆心y坐标
    double pieStart;//起始的角度
//    double pieCapacity;//角度增量值
    int clockwise;//0=逆时针,1=顺时针
    
    float curAngle;
}

@property (strong, nonatomic)UIImageView* disc;

@end

@implementation DiscView
@synthesize disc,edgeWidth,strokeColor,drawRadian,rotationSpeed,touch,isPlaying;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor clearColor]];
        strokeColor = [UIColor blackColor];
        rotationSpeed = 0.5f;
    }
    return self;
}

- (void)touchAction
{
    if (touch) {
        touch();
    }
}

- (void)setDisc:(UIImage*)image radius:(float)radius edgeWidth:(float)ewidth
{
    [self setEdgeWidth:ewidth];
    
    int width = radius*2;
    int height = radius*2;
    
    //扇形参数
    drawRadius = radius + ewidth;//半径
    startX=self.frame.size.width/2;//圆心x坐标
    startY=self.frame.size.height/2;//圆心y坐标
    pieStart=-90;//起始的角度
    drawRadian=0;//角度增量值
    clockwise=0;//0=逆时针,1=顺时针
    curAngle = 0;//当前旋转的角度
    isPlaying = YES;
    
    if (!disc) {
        disc = [[UIImageView alloc]init];
        [disc.layer setMasksToBounds:YES];
        [disc setClipsToBounds:YES];
        [disc setContentMode:UIViewContentModeScaleAspectFill];
        [disc setUserInteractionEnabled:YES];
        [self addSubview:disc];
        
        UITapGestureRecognizer* touchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
        [disc addGestureRecognizer:touchGesture];
    }
    [disc.layer setCornerRadius:radius];
    [disc setImage:image];
    [disc setFrame:CGRectMake((self.frame.size.width - width)/2, (self.frame.size.height - height)/2, width, height)];

    [self startAnimation];
    
    [self setNeedsDisplay];
}


- (void)startAnimation
{
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//    rotationAnimation.duration = 5;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 1000;
//    
//    [disc.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    isPlaying = YES;
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(curAngle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.001 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        disc.transform = endAngle;
    } completion:^(BOOL finished) {
        curAngle+=rotationSpeed;
        if (isPlaying) {
            [self startAnimation];
        }
    }];
}

- (void)stopAnimation
{
    isPlaying = NO;
}

- (void)setDrawRadius:(float)radian
{
    [self setDR:radian];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    //设置矩形填充颜色：红色
//    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
    //设置画笔颜色：黑色
//    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    //设置画笔线条粗细
    CGContextSetLineWidth(context, 1);
    
    //逆时针画扇形
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddArc(context, startX, startY, drawRadius, radians(pieStart), radians(pieStart+drawRadian), clockwise);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathEOFillStroke);
}


@end
