//
//  SenTestCase+fixture.m
//  QATestingKit
//
//  Created by Quentin ARNAULT on 23/01/13.
//  Copyright (c) 2013 Quentin Arnault. All rights reserved.
//
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

#import "SenTestCase+fixture.h"

@implementation SenTestCase (fixture)

- (NSDictionary *)dictionaryFromFixtureNamed:(NSString *)fixtureName {
    NSArray *fixtureNameComponents = [fixtureName componentsSeparatedByString:@"."];
    NSString *resourceName = [fixtureNameComponents objectAtIndex:0];
    NSString *resourceType = [fixtureNameComponents objectAtIndex:1];
    
    NSString *fixturePath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName ofType:resourceType];
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfFile:fixturePath
                                              options:0
                                                error:&error];
    NSDictionary *fixture = nil;
    
    if (jsonData) {
        id rawFixture = [NSJSONSerialization JSONObjectWithData:jsonData
                                                  options:0
                                                    error:&error];
        
        if ([rawFixture isKindOfClass:[NSDictionary class]]) {
            fixture = (NSDictionary *)rawFixture;
        }
    }
    
    return fixture;
}

@end
