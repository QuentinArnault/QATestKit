//
//  SenTestCase+stub.m
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

#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SenTestCase+stub.h"

static NSString * const kJsonExtension = @"json";
static NSTimeInterval kDefaultTimeout = .1f;
@implementation SenTestCase (stub)

#pragma mark -
- (void)stubRequestsWithURL:(NSURL *)requestURL withFixtureNamed:(NSString *)fixtureName {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse*(NSURLRequest *request, BOOL onlyCheck)
     {
         OHHTTPStubsResponse *response = nil;
         
         if ([request.URL isEqual:requestURL]) {
             response = [OHHTTPStubsResponse responseWithFile:fixtureName
                                                  contentType:[self contentTypeForFixtureName:fixtureName]
                                                 responseTime:kDefaultTimeout];
         }
         
         return response;
     }];
}

- (void)stubAllRequestsWithFixtureNamed:(NSString *)fixtureName {
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse*(NSURLRequest *request, BOOL onlyCheck)
     {
         return [OHHTTPStubsResponse responseWithFile:fixtureName
                                          contentType:[self contentTypeForFixtureName:fixtureName]
                                         responseTime:kDefaultTimeout];
     }];
}

- (void)resetStubs {
    [OHHTTPStubs removeAllRequestHandlers];
}

#pragma mark -
#pragma mark private
- (NSString *)contentTypeForFixtureName:(NSString *)fixtureName {
    NSString *fileExtension = [fixtureName pathExtension];
    
    NSString *contentType;
    if ([kJsonExtension isEqualToString:fileExtension]) {
        contentType = @"text/json";
    } else {
        contentType = @"text/plain";
    }
    
    return contentType;
}

@end
