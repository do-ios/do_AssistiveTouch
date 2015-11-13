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
@interface do_AssistiveTouch_SM()
@property (nonatomic, strong)UIImageView *imageView;
@end
@implementation do_AssistiveTouch_SM
#pragma mark - 方法
#pragma mark - 同步异步方法的实现
//同步
- (void)hideView:(NSArray *)parms
{
    //自己的代码实现
    self.imageView.hidden = YES;
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
    bool _isMove = YES;
    if (![_dictParas.allKeys containsObject:@"isMove"])
    {
        _isMove = YES;
    }
    else
    {
        _isMove = [_dictParas[@"isMove"] boolValue];
    }
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
    if (self.imageView.isHidden) {
        self.imageView.hidden = NO;
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self.imageView];
    [self setViewLocation:self.imageView];
}
//异步

#pragma mark - 私有方法
#pragma mark - 移动手势的实现
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self setViewLocation:view];
    }
}
//- (void) setViewLocation:(UIView *)view
//{
//    CGFloat superviewWidth = view.superview.frame.size.width;
//    CGFloat superviewHeight = view.superview.frame.size.height;
//    if (view.center.x < superviewWidth / 2)
//    {
//        if (view.center.y < superviewHeight / 2)
//        {
//            if ((superviewHeight / 2 - view.center.y) > (superviewWidth / 2 - view.center.x))
//            {
//                [view setCenter:(CGPoint){view.frame.size.width / 2, view.center.y}];
//            }
//            else
//            {
//                [view setCenter:(CGPoint){view.center.x, view.frame.size.height / 2}];
//            }
//        }
//        else
//        {
//            if ((superviewHeight - view.center.y) > (view.center.x))
//            {
//                [view setCenter:(CGPoint){view.frame.size.width / 2, view.center.y}];
//            }
//            else
//            {
//                [view setCenter:(CGPoint){view.center.x, superviewHeight - view.frame.size.height / 2}];
//            }
//        }
//    }
//    else
//    {
//        if (view.center.y < superviewHeight / 2)
//        {
//            if ((superviewHeight / 2 - view.center.y) > (superviewWidth - view.center.x))
//            {
//                [view setCenter:(CGPoint){view.center.x, view.frame.size.height / 2}];
//            }
//            else
//            {
//                [view setCenter:(CGPoint){superviewWidth - view.frame.size.width / 2, view.center.y}];
//            }
//        }
//        else
//        {
//            if ((superviewHeight - view.center.y) > (superviewWidth - view.center.x))
//            {
//                [view setCenter:(CGPoint){superviewWidth - view.frame.size.width / 2, view.center.y}];
//            }
//            else
//            {
//                [view setCenter:(CGPoint){view.center.x, superviewHeight - view.frame.size.height / 2}];
//            }
//        }
//    }
//}
- (void)setViewLocation:(UIView *)view
{
    CGFloat screenCenterX = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat screenCenterY = [UIScreen mainScreen].bounds.size.height / 2;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat viewCenterX = view.center.x;
    CGFloat viewCenterY = view.center.y;
    //1,3象限
    if (viewCenterX <= screenCenterX)
    {
        //1象限
        if (viewCenterY <= screenCenterY)
        {
            CGFloat minX = CGRectGetMinX(view.frame);
            CGFloat minY = CGRectGetMinY(view.frame);
            
            if (minX <= minY) {
                viewCenterX -= minX;
                if (viewCenterY < view.frame.size.height / 2) {//超过屏幕处理
                    viewCenterY = view.frame.size.height / 2;
                }
            }
            else
            {
                viewCenterY -= minY;
                if (viewCenterX < view.frame.size.width / 2) {
                    viewCenterX = view.frame.size.width / 2;
                }
            }
        }
        else//3象限
        {
            CGFloat minX = CGRectGetMinX(view.frame);
            CGFloat maxY = CGRectGetMaxY(view.frame);
            CGFloat offsetY = screenH - maxY;
            if (minX <= offsetY) {
                viewCenterX -= minX;
                if (offsetY < 0) {
                    viewCenterY += offsetY;
                }
            }
            else
            {
                viewCenterY += offsetY;
                if (viewCenterX < view.frame.size.width / 2) {
                    viewCenterX = view.frame.size.width / 2;
                }
            }
        }
    }
    else//2,4象限
    {
        //2象限
        if (viewCenterY <= screenCenterY)
        {
            CGFloat maxX = CGRectGetMaxX(view.frame);
            CGFloat minY = CGRectGetMinY(view.frame);
            CGFloat offsetX = screenW - maxX;
            if (offsetX <= minY) {
                viewCenterX += offsetX;
                if(minY < 0)
                {
                    viewCenterY -= minY;
                }
            }
            else
            {
                if (offsetX < 0) {
                    viewCenterX += offsetX;
                }
                viewCenterY -= minY;
            }
        }
        else//4象限
        {
            CGFloat maxX = CGRectGetMaxX(view.frame);
            CGFloat maxY = CGRectGetMaxY(view.frame);
            CGFloat offsetX = screenW - maxX;
            CGFloat offsetY = screenH - maxY;
            if (offsetX <= offsetY) {
                viewCenterX += offsetX;
                if (offsetY < 0) {
                    viewCenterY += offsetY;
                }
            }
            else
            {
                if (offsetX < 0) {
                    viewCenterX += offsetX;
                }
                viewCenterY += offsetY;
            }
        }
    }
    [view setCenter:CGPointMake(viewCenterX, viewCenterY)];
}
- (void) tapView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    doInvokeResult *_invokeResult = [[doInvokeResult alloc]init];
    [_invokeResult SetResultText:@"touch"];
    [self.EventCenter FireEvent:@"touch" :_invokeResult];
}
@end