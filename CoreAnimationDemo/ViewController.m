//
//  ViewController.m
//  CoreAnimationDemo
//
//  Created by bioongroup on 15/10/14.
//  Copyright © 2015年 ylk. All rights reserved.
//

#import "ViewController.h"

#define VIEW_HEIGHT  self.view.frame.size.height
#define VIEW_WEIGHT  self.view.frame.size.width

@interface ViewController (){
    //创建一个数组来放置下方的四个按钮
    NSMutableArray* _downBtnArr;
    BOOL _orClick;
    //测试view
    UIView *_testView;
    //clickBtn
    UIButton *_clickbtn;
    //测试view的数组
    NSMutableArray *_testViewArr;
    //NSrimer
    NSTimer *_nstimer;
    //背景
    UIView *_backView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**创建测试View**/
    //_testView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 40, 40)];
    //_testView.backgroundColor = [UIColor redColor];
    //[self.view addSubview:_testView];
    // Do any additional setup after loading the view, typically from a nib.
    /**创建旋转按钮**/
    _clickbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickbtn.frame = CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height-50, 50, 50);
    [_clickbtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [_clickbtn setImage:[UIImage imageNamed:@"add_btn.png"] forState:UIControlStateNormal];
    /**创建底层的view**/
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, VIEW_HEIGHT)];
    _backView.backgroundColor = [UIColor grayColor];
    _backView.alpha = 0.3;
    [self.view addSubview:_backView];
    /****************/
    [self.view addSubview:_clickbtn];
    //创建4个view
    [self createDownView];
}
//全局变量
int whitchView=0;
#pragma mark - clickMethod
//按钮点击时候的方法
-(void)click{
    _orClick = !_orClick;
    _nstimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(update) userInfo:nil repeats:YES];
    _clickbtn.userInteractionEnabled=NO;
    [self rotateTheButton];
    [self moveBackView];
}


#pragma mark - 按钮上弹
//创建下方四个按钮滑动的动画
-(void)roadAnimation{
    CAKeyframeAnimation* keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    keyframeAnimation.delegate =self;
    /*
     * mark
     */
    if(_orClick){
    keyframeAnimation.values = @[[NSNumber numberWithFloat:VIEW_HEIGHT+40],[NSNumber numberWithFloat:VIEW_HEIGHT-140],[NSNumber numberWithFloat:VIEW_HEIGHT-110],[NSNumber numberWithFloat:VIEW_HEIGHT-115]];
    keyframeAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0.40f],[NSNumber numberWithFloat:0.65f],[NSNumber numberWithFloat:0.8f]];
    keyframeAnimation.duration = 1.0f;
    }else{
    keyframeAnimation.values = @[[NSNumber numberWithFloat:VIEW_HEIGHT-115],[NSNumber numberWithFloat:VIEW_HEIGHT-110],[NSNumber numberWithFloat:VIEW_HEIGHT-140],[NSNumber numberWithFloat:VIEW_HEIGHT+40]];
    keyframeAnimation.keyTimes = @[[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:0.20f],[NSNumber numberWithFloat:0.35f],[NSNumber numberWithFloat:0.6f]];
    keyframeAnimation.duration = 0.7f;
    }
    
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    UIView *view = [_testViewArr objectAtIndex:whitchView];
    view.backgroundColor = [UIColor redColor];
    //[self.view addSubview:view];
    [_backView addSubview:view];
    [view.layer addAnimation:keyframeAnimation forKey:@"keyframeAtion"];
}

//Clickbutton Rotate
-(void)rotateTheButton{
    CABasicAnimation* rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if(_orClick){
        rotation.fromValue = [NSNumber numberWithFloat:0.0f];
        rotation.toValue = [NSNumber numberWithFloat:M_PI/4];
    }else{
        rotation.fromValue =[NSNumber numberWithFloat:M_PI/4];
        rotation.toValue = [NSNumber numberWithFloat:0.0f];
    }
    rotation.duration = 0.5f;
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeForwards;
    [_clickbtn.layer addAnimation:rotation forKey:@"rotation"];
}

//NSTimer Method
-(void)update{
    [self roadAnimation];
    whitchView++;
    if(whitchView>=[_testViewArr count]){
        [_nstimer invalidate];
        _nstimer = nil;
        whitchView =0;
        _clickbtn.userInteractionEnabled = YES;
        return;
    }
}

#pragma mark - createDonwView
-(void)createDownView{
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/5-20, VIEW_HEIGHT+40, 40, 40)];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/5*2-20, VIEW_HEIGHT+40, 40, 40)];
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/5*3-20, VIEW_HEIGHT+40, 40, 40)];
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(VIEW_WEIGHT/5*4-20, VIEW_HEIGHT+40, 40, 40)];
    _testViewArr = [[NSMutableArray alloc]initWithObjects:view1,view2,view3,view4, nil];
}

#pragma mark - moveBackView
-(void)moveBackView{
    if(_orClick){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        _backView.center = CGPointMake(_backView.center.x, VIEW_HEIGHT/2);
        [UIView commitAnimations];
    }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        _backView.center = CGPointMake(_backView.center.x, VIEW_HEIGHT*1.5);
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
