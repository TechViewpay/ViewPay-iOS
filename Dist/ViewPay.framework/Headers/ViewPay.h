//
//  ViewPay.h
//  ViewPay
//
//  Created by Thibaut LE LEVIER on 29/11/2017.
//  Copyright © 2017 ViewPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VPAdStatus)  {
    VPAdStatusSuccess,
    VPAdStatusNoAd,
    VPAdStatusCancelled,
    VPAdStatusError
};

typedef NS_ENUM(NSUInteger, VPUserGender) {
    VPUserGenderNotSet,
    VPUserGenderMale,
    VPUserGenderFemale,
    VPUserGenderOther
};

@interface ViewPay : NSObject

+ (void)setAccountID:(nonnull NSString *)accountID;

+ (void)setUserGender:(VPUserGender)gender;
+ (void)setUserAge:(int)age;

+ (void)presentAdWithCallback:(nonnull void (^)(VPAdStatus status))callback;
+ (void)checkVideoWithContentCategory:(nullable NSString *)category andCallback:(nonnull void (^)(BOOL success, NSError *error))callback;

@end
