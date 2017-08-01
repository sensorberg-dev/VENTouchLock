//
//  VENTouchLockEvent.h
//  VENTouchLock
//
//  Created by ParkSanggeon on 01.08.17.
//  Copyright © 2017 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VENTouchLockPassCodeInputType) {
    VENTouchLockPassCodeInputTypeFirst,
    VENTouchLockPassCodeInputTypeConfirm
};

#if !defined(VENTouchLockTouchIDResponse)
#define VENTouchLockTouchIDResponse NSUInteger
#endif //#ifndef VENTouchLockTouchIDResponse

#pragma mark - Abastract Classes (Do not SUBSCRIBE these abtract events.)
@interface VENTouchLockEvent : NSObject
@end

@interface VENTouchLockEventPasscodeResult : VENTouchLockEvent
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) BOOL userCanceled;
@end

#pragma mark - Actual Classes to Listen

@interface VENTouchLockEventLocked : VENTouchLockEvent
@end

@interface VENTouchLockEventUnlockTouchID : VENTouchLockEvent
@end

@interface VENTouchLockEventUnlockTouchIDResponse : VENTouchLockEvent
@property (nonatomic, assign) VENTouchLockTouchIDResponse response;
@end

@interface VENTouchLockEventCreatePasscode : VENTouchLockEvent
@property (nonatomic, assign) VENTouchLockPassCodeInputType inputType;
@end

@interface VENTouchLockEventCreatePasscodeResult : VENTouchLockEventPasscodeResult
@end

@interface VENTouchLockEventUnlockPasscode : VENTouchLockEvent
@end

@interface VENTouchLockEventUnlockPasscodeResult : VENTouchLockEventPasscodeResult
@end
