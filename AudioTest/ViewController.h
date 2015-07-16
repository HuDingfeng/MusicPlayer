//
//  ViewController.h
//  AudioTest
//
//  Created by hdf on 14-8-21.
//  Copyright (c) 2014年 胡定锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioPlayerDelegate>

@property(nonatomic,strong)AVAudioPlayer *player;
@property(nonatomic,strong)NSMutableArray *snowArray;
@property(nonatomic, strong)NSArray *musicArr;
@property(nonatomic, assign)NSInteger songIndex;
@property(nonatomic, strong)UILabel *labelShow;
@end
