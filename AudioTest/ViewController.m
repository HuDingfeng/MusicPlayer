//
//  ViewController.m
//  AudioTest
//
//  Created by hdf on 14-8-21.
//  Copyright (c) 2014年 胡定锋. All rights reserved.
//

#import "ViewController.h"
#import "ResusedImageView.h"
#import "MusicList.h"
#define SNOW_WIDTH 30
#define SNOW_HEIGHT 30
@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _musicArr = [NSArray arrayWithObjects:@"只凝视着你",@"偏爱",@"时间长了受不了",@"真的爱你",@"离不开你", nil];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
//控件布局
    [self creatButtonView];
    
    [self showName];

    
    
    MusicList *musicList = [MusicList new];
    musicList.frame = CGRectMake(60, 150 ,200,300);
    musicList.layer.cornerRadius = 8;
    musicList.layer.borderColor = [UIColor purpleColor].CGColor;
    musicList.layer.borderWidth = 2;
    [self.view addSubview:musicList];
    
//设置播放器
    [self loadMusic:[_musicArr objectAtIndex:0] type:@"mp3"];
//雪花飘落
    _snowArray = [[NSMutableArray alloc]initWithCapacity:20];
	for (int index = 0; index < 20; index++) {
        //加载一个图片
		ResusedImageView* snow = [[ResusedImageView alloc]
                                 initWithImage:[UIImage imageNamed:@"flake"]];
		//雪花的初始坐标
		snow.frame = CGRectMake(0, -SNOW_HEIGHT, SNOW_WIDTH, SNOW_HEIGHT);
		//设置雪花的初始使用状态为no
		snow.isUsed = NO;
		//
		[_snowArray addObject:snow];
		//让雪花在view上显示出来
		[self.view addSubview:snow];
	}
	
	//与下面的ontimer相应
	[NSTimer scheduledTimerWithTimeInterval:0.07
                                     target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
	
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    
}

//前进、播放、后退的button创建；
-(void)creatButtonView
{
    
    UIButton * playBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(125, 450, 70, 70);
    playBtn.layer.cornerRadius = 70/2;
    playBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    playBtn.layer.borderWidth = 2;
    playBtn.backgroundColor  =[UIColor clearColor];
    [playBtn setHighlighted:YES];
    playBtn.selected = YES;
    [playBtn setImage:[UIImage imageNamed:@"moviePlay"] forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];

    
    UIButton * leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(70, 480, 40, 30);
    [leftBtn setHighlighted:YES];
    [leftBtn setImage:[UIImage imageNamed:@"movieBackward"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(prier) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(210, 480, 40, 30);
    [rightBtn setHighlighted:YES];
    [rightBtn setImage:[UIImage imageNamed:@"movieForward"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

//播放暂停
-(void)buttonClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.selected == YES) {
        btn.selected = NO;
       // [btn setTitle:@"|  |" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"moviePause"] forState:UIControlStateNormal];

        [self play];
        
        
        
    }else
    {
        btn.selected =YES;
        //[btn setTitle:@"|  >" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"moviePlay"] forState:UIControlStateNormal];

        [self stop];
    }

}
//跑马灯的实现
-(void)showName
{
    //跑马灯;
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 30)];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.alpha = 0.5;
    _labelShow = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    _labelShow.text =[_musicArr objectAtIndex:_songIndex];
    _labelShow.textColor = [UIColor whiteColor];
    
   // [_labelShow sizeToFit];//设置label自适应字体;calls sizeThatFits: with current view bounds and changes bounds size.
    CGRect frame = _labelShow.frame;
    frame.origin.x = 320;
    _labelShow.frame = frame;
    
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:8.8f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:999999];
    
    frame = _labelShow.frame;
    frame.origin.x = -frame.size.width;
    _labelShow.frame = frame;
    [UIView commitAnimations];
    
    [contentView addSubview:_labelShow];
    [self.view addSubview:contentView];

}

- (void)play {

 [_player play];
    
}
- (void)pause
{
    
  [self.player pause];
  
}
- (void)stop
{
     [self.player stop];
}


-(void)onTimer
{   //设置一个静态变量，调用一次之后不再使用。
	static int count = 0;
	count++;
	if(count > 20)
	{
		count = 0;
		[self findAnUnsedSnow];
	}
	
	[self flowDownAllSnows];
}

-(void)findAnUnsedSnow
{
	//找一个未使用的雪花
	for (ResusedImageView* snow in self.snowArray)
	{
		if (snow.isUsed == NO) {
			int xPos = arc4random()%(321-SNOW_WIDTH);
			//设置未使用雪花开始时的初始坐标
			snow.frame = CGRectMake(xPos, -SNOW_HEIGHT, SNOW_WIDTH, SNOW_HEIGHT);
			snow.isUsed = YES;
			break;
		}
	}
}

-(void)flowDownAllSnows
{
	//让所有的雪花都飘落
	for (ResusedImageView* snow in self.snowArray)
	{
		if (snow.isUsed == YES)
		{
			CGRect rect = snow.frame;
			rect.origin.y += 5;
			snow.frame = rect;
			if (snow.frame.origin.y > 480) {
				snow.isUsed = NO;
			}
		}
	}
}
//封装系统加载函数
-(void)loadMusic:(NSString*)name type:(NSString*)type
{
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    _player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_player prepareToPlay];
    _player.volume = 1;
    //_player.numberOfLoops = -1;
    _player.delegate = self;
}
//上一首
-(void)prier
{
    BOOL playFlag;
    if(_player.playing)
    {
        playFlag=YES;
        [_player stop];
    }
    else
    {
        playFlag=NO;
    }
    _songIndex--;
    if(_songIndex<0)
        _songIndex= _musicArr.count-1
        ;

    [self loadMusic:[_musicArr objectAtIndex:_songIndex] type:@"mp3"];
    _labelShow.text= [_musicArr objectAtIndex:_songIndex];
    
    if(playFlag==YES)
    {
        [_player play];
        
    }
}

//下一首
-(void)next
{
    BOOL playFlag;
    if(_player.playing)
    {
        playFlag=YES;
        [_player stop];
    }
    else
        playFlag=NO;
    _songIndex++;
    if(_songIndex==_musicArr.count)
        _songIndex= 0;
    
    [self loadMusic:[_musicArr objectAtIndex:_songIndex] type:@"mp3"];
    _labelShow.text= [_musicArr objectAtIndex:_songIndex];
    if(playFlag==YES)
    {
        [_player play];
        
    }
    
}

//播放完成自动切换
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _songIndex++;
    if(_songIndex==_musicArr.count)
        _songIndex= 0;

    [self loadMusic:[_musicArr objectAtIndex:_songIndex] type:@"mp3"];
    _labelShow.text= [_musicArr objectAtIndex:_songIndex];
    [_player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showTime
{
    
}



@end
