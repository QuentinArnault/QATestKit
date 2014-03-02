//
//  XCTestCase+async.m
//  QATestkit
//
//  Copyright (c) 2014 Quentin Arnault. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <objc/runtime.h>

#import "XCTestCase+async.h"

static NSString * const kQANotifiedKey = @"kQANotifiedKey";
static NSString * const kQALoopUntilKey = @"kQALoopUntilKey";
static NSString * const kQANotifiedStatusKey = @"kQANotifiedStatusKey";
static NSString * const kQAExpectedStatusKey = @"kQAExpectedStatusKey";

@interface XCTestCase ()

@property (nonatomic, retain) NSDate *loopUntil;
@property (nonatomic, assign) BOOL notified;
@property (nonatomic, assign) XCTestCaseAsyncStatus notifiedStatus;
@property (nonatomic, assign) XCTestCaseAsyncStatus expectedStatus;

@end

@implementation XCTestCase (async)

#pragma mark -
- (void)waitForTimeout:(NSTimeInterval)timeout
{
    self.notified = NO;
    self.expectedStatus = XCTestCaseAsyncStatusUnknown;
    self.loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    while (!self.notified && [self.loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    if (self.notified) {
        XCTFail(@"Async test not timed out.");
    }
}

- (void)waitForStatus:(XCTestCaseAsyncStatus)status withTimeout:(NSTimeInterval)timeout
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
            XCTFail(@"Notified status does not match the expected status.");
        }
    } else {
        XCTFail(@"Async test timed out.");
    }
}

- (void)notify:(XCTestCaseAsyncStatus)status {
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

- (void)setNotifiedStatus:(XCTestCaseAsyncStatus)notifiedStatus {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQANotifiedStatusKey)
                             , [NSNumber numberWithInt:notifiedStatus]
                             , OBJC_ASSOCIATION_COPY);
}

- (XCTestCaseAsyncStatus)notifiedStatus {
    NSNumber *notifiedObject = objc_getAssociatedObject(self
                                                        , (__bridge const void *)kQANotifiedStatusKey);
    
    return [notifiedObject intValue];
}

- (void)setExpectedStatus:(XCTestCaseAsyncStatus)expectedStatus {
	objc_setAssociatedObject(self
                             , (__bridge const void *)(kQAExpectedStatusKey)
                             , [NSNumber numberWithInt:expectedStatus]
                             , OBJC_ASSOCIATION_COPY);
}

- (XCTestCaseAsyncStatus)expectedStatus {
    NSNumber *expectedStatus = objc_getAssociatedObject(self
                                                        , (__bridge const void *)kQAExpectedStatusKey);
    
    return [expectedStatus intValue];
}

@end
