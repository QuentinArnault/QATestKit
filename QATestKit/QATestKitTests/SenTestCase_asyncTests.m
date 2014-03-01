//
//  SenTestCase_asyncTests.m
//  SenTestCase_asyncTests
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

#import <SenTestingKit/SenTestingKit.h>
#import "SenTestCase+async.h"

@interface SenTestCase_asyncTests : SenTestCase

@end

@implementation SenTestCase_asyncTests

#pragma mark -
- (void)test_should_succeed_if_notified_before_timeout {
    
    int64_t delayInSeconds = .5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self notify:SenTestCaseAsyncStatusSucceeded];
    });
    
    [self waitForStatus:SenTestCaseAsyncStatusSucceeded withTimeout:1.f];
}

- (void)test_should_reach_timeout_if_no_status_is_notified {
    
    [self waitForTimeout:1.f];
}

#pragma mark -
#pragma mark SenTestCase
- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

@end
