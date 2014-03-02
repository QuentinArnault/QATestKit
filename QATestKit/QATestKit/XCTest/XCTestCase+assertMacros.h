//
//  XCTestCase+assertMacros.h
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


#import <XCTest/XCTest.h>

NSString *QAComposeString(NSString *formatString, ...);
    
#define XCTAssertGreaterThan(a1, a2, description, ...) \
XCTAssertOperation(a1, a2, >, description, ##__VA_ARGS__)

#define XCTAssertGreaterThanOrEqual(a1, a2, description, ...) \
XCTAssertOperation(a1, a2, >=, description, ##__VA_ARGS__)

#define XCTAssertLessThan(a1, a2, description, ...) \
XCTAssertOperation(a1, a2, <, description, ##__VA_ARGS__)

#define XCTAssertLessThanOrEqual(a1, a2, description, ...) \
XCTAssertOperation(a1, a2, <=, description, ##__VA_ARGS__)

#define XCTAssertOperation(a1, a2, op, description, ...) \
do { \
@try {\
if (strcmp(@encode(typeof(a1)), @encode(typeof(a2))) != 0) { \
[self recordFailureWithDescription:[@"Type mismatch -- " stringByAppendingString:QAComposeString(description, ##__VA_ARGS__)] \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ expected:NO];\
} else { \
typeof(a1) a1value = (a1); \
typeof(a2) a2value = (a2); \
if (!(a1value > a2value)) { \
double a1DoubleValue = a1value; \
double a2DoubleValue = a2value; \
NSString *expression = [NSString stringWithFormat:@"%s (%lg) %s %s (%lg)", #a1, a1DoubleValue, #op, #a2, a2DoubleValue]; \
if (description) { \
expression = [NSString stringWithFormat:@"%@: %@", expression, QAComposeString(description, ##__VA_ARGS__)]; \
} \
[self recordFailureWithDescription:expression \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ expected:NO];\
} \
} \
} \
@catch (id anException) {\
[self recordFailureWithDescription:QAComposeString(description, ##__VA_ARGS__) \
inFile:[NSString stringWithUTF8String:__FILE__] \
atLine:__LINE__ expected:NO];\
}\
} while(0)

