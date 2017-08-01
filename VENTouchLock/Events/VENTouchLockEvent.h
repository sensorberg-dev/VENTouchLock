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

// when the app is locked.
@interface VENTouchLockEventLocked : VENTouchLockEvent
@end

// when unlock with TouchID screen is appeared
@interface VENTouchLockEventUnlockTouchID : VENTouchLockEvent
@end

@interface VENTouchLockEventUnlockTouchIDResponse : VENTouchLockEvent
@property (nonatomic, assign) VENTouchLockTouchIDResponse response;
@end

// when Create passcode screen is appeared (first and confirm inputs)
@interface VENTouchLockEventCreatePasscode : VENTouchLockEvent
@property (nonatomic, assign) VENTouchLockPassCodeInputType inputType;
@end

@interface VENTouchLockEventCreatePasscodeResult : VENTouchLockEventPasscodeResult
@end

// when unlock with passcode screen is appeared
@interface VENTouchLockEventUnlockPasscode : VENTouchLockEvent
@end

// when user entered wrong passcode
@interface VENTouchLockEventUnlockPasscodeIncorrect : VENTouchLockEvent
@end

// when user entered wrong passcode over certain times.
@interface VENTouchLockEventUnlockPasscodeAttemptLimitExceeded : VENTouchLockEvent
@end

// when it's completely failed to unlock with passcode
@interface VENTouchLockEventUnlockPasscodeResult : VENTouchLockEventPasscodeResult
@end
