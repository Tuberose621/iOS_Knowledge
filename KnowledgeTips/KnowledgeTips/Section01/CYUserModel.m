//
//  CYUserModel.m
//  KnowledgeTips
//
//  Created by 葛聪颖 on 2020/4/22.
//  Copyright © 2020 葛聪颖. All rights reserved.
//

#import "CYUserModel.h"

@implementation CYUserModel

static CYUserModel *g_userNodel;

+ (CYUserModel *)shareInstance {
    if (!g_userNodel) {
        g_userNodel = [[CYUserModel alloc] init];
    }
    return g_userNodel;
}

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age userGender:(CYUserGender)userGender {
    if (self = [super init]) {
        _name = name;
        _age = age;
        _userGender = userGender;
    }
    return self;
}

- (void)typeOfAgeProperty {
    /**
     age 属性的类型：应避免使用基本类型，建议使用 Foundation 数据类型，对应关系如下：
     int -> NSInteger
     unsigned -> NSUInteger
     float -> CGFloat
     动画时间 -> NSTimeInterval
     同时考虑到 age 的特点，应使用 NSUInteger ，而非 int 。 这样做的是基于64-bit 适配考虑
     */
}

@end

