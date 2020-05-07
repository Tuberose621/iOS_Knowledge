//
//  CYUserModel.h
//  KnowledgeTips
//
//  Created by 葛聪颖 on 2020/4/22.
//  Copyright © 2020 葛聪颖. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CYUserGender) {
    CYUserGenderUnknown,
    CYUserGenderMale,
    CYUserGenderFemale,
    CYUserGenderNeuter
};

@interface CYUserModel : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSInteger age;
@property (nonatomic, readonly, assign) CYUserGender userGender;

- (instancetype)initWithName:(NSString *)name age:(NSInteger)age userGender:(CYUserGender)userGender;

@end

NS_ASSUME_NONNULL_END
