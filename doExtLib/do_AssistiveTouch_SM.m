//
//  do_AssistiveTouch_SM.m
//  DoExt_API
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_AssistiveTouch_SM.h"
#import "doIOHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doInvokeResult.h"
#import "doIPage.h"
@implementation do_AssistiveTouch_SM
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
- (void)hideView:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    self.imageView.hidden = YES;
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    
}
- (void)showView:(NSArray *)parms
{
    NSDictionary *_dictParas = [parms objectAtIndex:0];
    //参数字典_dictParas
    id<doIScriptEngine> _scritEngine = [parms objectAtIndex:1];
    //自己的代码实现
    NSString *_location = _dictParas[@"location"];
    NSString *_sourceImgPath = _dictParas[@"image"];
    bool _isMove = [_dictParas[@"isMove"] boolValue];
    if (_location == nil || _location.length == 0)
    {
        return;
    }
    
    NSString *_imgPath = [doIOHelper GetLocalFileFullPath: _scritEngine.CurrentPage.CurrentApp :_sourceImgPath];
    UIImage *_image = [[UIImage alloc]initWithContentsOfFile:_imgPath];
    NSArray *_array = [_location componentsSeparatedByString:@","];
    if (_array.count == 0 || _array.count == 1)
    {
        return;
    }
    CGFloat x = [_array[0] floatValue];
    CGFloat y = [_array[1] floatValue];
    CGFloat width = _image.size.width;
    CGFloat height = _image.size.height;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.imageView.image = _image;
    [self.imageView setNeedsDisplay];
    [[UIApplication sharedApplication].keyWindow addSubview:self.imageView];
    self.imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *_panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    if (_isMove)
    {
        [self.imageView addGestureRecognizer:_panGestureRecognizer];
    }
    else
    {
        [self.imageView removeGestureRecognizer:_panGestureRecognizer];
    }
    UITapGestureRecognizer *_singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self.imageView addGestureRecognizer:_singleTap];
    doInvokeResult *_invokeResult = [parms objectAtIndex:2];
    //_invokeResult设置返回值
    
}
//异步

#pragma mark - 私有方法
#pragma mark - 移动手势的实现
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

- (void) tapView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    doInvokeResult *_invokeResult = [[doInvokeResult alloc]init];
    [_invokeResult SetResultText:@"touch"];
    [self.EventCenter FireEvent:@"touch" :_invokeResult];
}
@end