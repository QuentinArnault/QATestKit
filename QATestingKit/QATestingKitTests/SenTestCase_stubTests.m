//
//  SenTestCase_stubTests.m
//  QATestingKit
//
//  Created by Quentin ARNAULT on 26/12/12.
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
#import "SenTestCase+stub.h"
#import "SenTestCase+async.h"

@interface SenTestCase_stubTests : SenTestCase

@end

@implementation SenTestCase_stubTests

#pragma mark -
- (void)test_should_stub_any_request {
    [self stubAllRequestsWithFixtureNamed:@"answer.json"];
    
    NSURL *anyURL = [NSURL URLWithString:@"http://www.anyurl.com/answer.json"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:anyURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ((response) && (data) && (!error)) {
                                   [self notify:SenTestCaseAsyncStatusSucceeded];
                               } else {
                                   [self notify:SenTestCaseAsyncStatusFailed];
                               }
                           }];
    
    [self waitForStatus:SenTestCaseAsyncStatusSucceeded
            withTimeout:.5f];
}

- (void)test_should_reset_stubs {
    [self stubAllRequestsWithFixtureNamed:@"answer.json"];
    
    [self resetStubs];
    
    NSURL *anyURL = [NSURL URLWithString:@"http://www.anyurl.com/answer.json"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:anyURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ((response) && (data) && (!error)) {
                                   [self notify:SenTestCaseAsyncStatusSucceeded];
                               }
                           }];
    
    [self waitForTimeout:.5f];
}

- (void)test_should_stub_only_for_one_specific_request {
    NSURL *anURL = [NSURL URLWithString:@"http://www.anyurl.com/answer.json"];
    
    [self stubRequestsWithURL:anURL
            withFixtureNamed:@"answer.json"];

    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:anURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ((response) && (data) && (!error)) {
                                   [self notify:SenTestCaseAsyncStatusSucceeded];
                               }
                           }];
    
    [self waitForStatus:SenTestCaseAsyncStatusSucceeded
            withTimeout:.5f];
}


- (void)test_should_not_stub_for_other_request {
    NSURL *anURL = [NSURL URLWithString:@"http://www.anyurl.com/answer.json"];
    NSURL *anotherURL = [NSURL URLWithString:@"http://www.anyurl.com/answer2.json"];
    
    [self stubRequestsWithURL:anURL
            withFixtureNamed:@"answer.json"];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:anotherURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ((response) && (data) && (!error)) {
                                   [self notify:SenTestCaseAsyncStatusSucceeded];
                               }
                           }];
    
    [self waitForTimeout:.5f];
}

@end
