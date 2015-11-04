//
//  do_AssistiveTouch_App.m
//  DoExt_SM
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_AssistiveTouch_App.h"
static do_AssistiveTouch_App* instance;
@implementation do_AssistiveTouch_App
@synthesize OpenURLScheme;
+(id) Instance
{
    if(instance==nil)
        instance = [[do_AssistiveTouch_App alloc]init];
    return instance;
}
@end
