//
//  ViewController.m
//  DiscExample
//
//  Created by hwk on 13-11-27.
//
//

#import "ViewController.h"
#import "DiscView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DiscView* disc = [[DiscView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [disc setDisc:[UIImage imageNamed:@"test.jpg"] radius:100 edgeWidth:10];
    __weak DiscView* _disc = disc;
    [disc setTouch:^(){
        if (_disc != nil) {
            if ([_disc isPlaying]) {
                [_disc stopAnimation];
            }else{
                [_disc startAnimation];
            }
        }
    }];
    [self.view addSubview:disc];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        do {
            float radian = [disc drawRadian];
            radian+=0.05;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_disc isPlaying]){
                    [disc setDrawRadius:radian];
                    if ([disc drawRadian]>=360) {
                        [disc stopAnimation];
                    }
                }
            });
            [NSThread sleepForTimeInterval:0.001];
        } while ([disc drawRadian]<360);
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
