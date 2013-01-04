# QATestingKit

The idea of this kit is to offer a better experience while writing UnitTests with SenTestingKit. I want to write my tests quicker and I want them to be more readable, I hope QATestingKit will help.

# FEATURES
 - Asynchronous test cases
 - Stub network requests

# INSTALL
 - Extract a tarball or zipball of the repository into your project directory.
 - Add 'QATestingKit/QATestingKit.xcodeproj' as a subproject in your workspace.
 - Add libQATestingKit.a to 'Link Binary With Libraries' phase of your test target.
 - QATestingKit takes advantage of Objective C's ability to add categories on an object, but this isn't enabled for static libraries by default. To enable this, add the '-ObjC' flag to the "Other Linker Flags" build setting.
 - Your .app must be linked against the following frameworks in addition to QATestingKit.a
 	- SenTestingKit.framework
 - In your test target Build Settings, add "$(CONFIGURATION_BUILD_DIR)/usr/local/include"(with quotes) as a non-recursive Header Search Path.
 
# HOW-TO

## Asynchronous test cases

First, import SenTestCase category header.

	#import "SenTestCase+async.h"

Then, write an asynchronous unit test.

	- (void)test_should_succeed {
		[objectUnderTest doSomethingWithSuccessBlock:^{
			[self notifiy:SenTestCaseAsyncStatusSucceeded];
		}];
		
		[self waitForStatus:waitForStatus withTimeout:1.f];
	}

## Stub network requests

First, import SenTestCase category header.

	#import "SenTestCase+async.h"

Then, add a fixture (answer.json) in your test project and add it to your test target.

Finally, write a test and specify that all requests will be stubbed with your fixture answer.json.

	- (void)test_should_stub_any_request {
    	[self stubAllRequestsWithFixtureNamed:@"answer.json"];
    
    	NSURL *anyURL = [NSURL URLWithString:@"http://www.anyurl.com/answer.json"];
    	[NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:anyURL]
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                           }];
	}

It is also possible to provide a stub for specific urls.

To provide this stubbing capabilities, QATestingKit uses the power of OHHTTPStubs.

# LICENSE
Copyright (c) 2012 Quentin Arnault

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# CREDITS
This project is brought to you by Quentin Arnault and is under MIT License.

Code for asynchronous test cases was inspired by https://github.com/akisute/SenAsyncTestCase.

Request stubbing is based on OHHTTPStubs https://github.com/AliSoftware/OHHTTPStubs.

# TODO LIST
 - fast fixture loading
 - better asserts macros
 - cocoapod compatibility
 - OCMock integration
 - OCHamcrest integration
 - ...
 
 Feel free to suggest some cool features.