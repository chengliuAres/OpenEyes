//
//  ViideoPlayerVC.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/25.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "ViideoPlayerVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ViideoPlayerVC ()
@property (nonatomic,weak) AVPlayer *player;
@end

@implementation ViideoPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AVPlayerViewController * av=[[AVPlayerViewController alloc] init];
    av.player =[AVPlayer playerWithURL:[NSURL URLWithString:_urlStr]];
    av.view.frame = self.view.bounds;
    [self addChildViewController:av];
    [self.view addSubview:av.view];
    _player = av.player;
}

/**
 支持哪些方向
 */
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

//默认显示方向
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_player) {
        _player =nil;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
