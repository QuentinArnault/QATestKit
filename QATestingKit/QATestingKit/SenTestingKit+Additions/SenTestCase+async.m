//
//  SenTestCase+async.m
//  QATestingKit
//
//  Created by Quentin ARNAULT on 24/12/12.
//
//  Copyright (c) 2012 Quentin Arnault
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  This class source code was largely inspired by https://github.com/akisute/SenAsyncTestCase

#import <objc/runtime.h>

#import "SenTestCase+async.h"

static NSString * const kQANotifiedKey = @"kQANotifiedKey";
static NSString * const kQALoopUntilKey = @"kQALoopUntilKey";
static NSString * const kQANotifiedStatusKey = @"kQANotifiedStatusKey";
static NSString * const kQAExpectedStatusKey = @"kQAExpectedStatusKey";

@interface SenTestCase ()

@property (nonatomic, retain) NSDate *loopUntil;
@property (nonatomic, assign) BOOL notified;
@property (nonatomic, assign) SenTestCaseAsyncStatus notifiedStatus;
@property (nonatomic, assign) SenTestCaseAsyncStatus expectedStatus;

@end

@implementation SenTestCase (async)

#pragma mark -
- (void)waitForTimeout:(NSTimeInterval)timeout
{
    self.notified = NO;
    self.expectedStatus = SenTestCaseAsyncStatusUnknown;
    self.loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!self.notified && [self.loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    if (self.notified) {
        STFail(@"Async test not timed out.");
    }
}

- (void)waitForStatus:(SenTestCaseAsyncStatus)status withTimeout:(NSTimeInterval)timeout
{
    self.notified = NO;
    self.expectedStatus = status;
    self.loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!self.notified && [self.loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    // Only assert when notified. Do not assert when timed out
    // Fail if not notified
    if (self.notified) {
        if (self.notifiedStatus != self.expectedStatus) {
            STFail(@"Notified status does not match the expected status.");
        }
    } else {
        STFail(@"Async test timed out.");
    }
}

- (void)notify:(SenTestCaseAsyncStatus)status {
    self.notifiedStatus = status;
    // self.notified must be set at the last of this method
    self.notified = YES;
}


#pragma mark -
#pragma mark properties
- (void)setNotified:(BOOL)notified {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQANotifiedKey)
                             , [NSNumber numberWithBool:notified]
                             , OBJC_ASSOCIATION_COPY);
}

- (BOOL)notified {
    NSNumber *notifiedObject = objc_getAssociatedObject(self
                                                        , (__bridge const void *)kQANotifiedKey);
    
    return [notifiedObject boolValue];
}

- (void)setLoopUntil:(NSDate *)loopUntil {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQALoopUntilKey)
                             , loopUntil
                             , OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate *)loopUntil {
    return objc_getAssociatedObject(self, (__bridge const void *)kQALoopUntilKey);
}

- (void)setNotifiedStatus:(SenTestCaseAsyncStatus)notifiedStatus {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQANotifiedStatusKey)
                             , [NSNumber numberWithInt:notifiedStatus]
                             , OBJC_ASSOCIATION_COPY);
}

- (SenTestCaseAsyncStatus)notifiedStatus {
    NSNumber *notifiedObject = objc_getAssociatedObject(self
                                                        , (__bridge const void *)kQANotifiedStatusKey);
    
    return [notifiedObject intValue];
}

- (void)setExpectedStatus:(SenTestCaseAsyncStatus)expectedStatus {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQAExpectedStatusKey)
                             , [NSNumber numberWithInt:expectedStatus]
                             , OBJC_ASSOCIATION_COPY);
}

- (SenTestCaseAsyncStatus)expectedStatus {
    NSNumber *expectedStatus = objc_getAssociatedObject(self
                                                        , (__bridge const void *)kQAExpectedStatusKey);
    
    return [expectedStatus intValue];
}
@end
