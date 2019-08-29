//
//  LJXTypeInstance.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXTypeInstance.h"

@implementation LJXTypeInstance

-(instancetype)init {
    if (self = [super init]) {
        self.btnItems = [NSMutableArray array];
    }
    return self;
}

+ (instancetype) sharedInstance {
    static LJXTypeInstance * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[LJXTypeInstance alloc] init];
        }
    });
    return _instance;
}

@end
