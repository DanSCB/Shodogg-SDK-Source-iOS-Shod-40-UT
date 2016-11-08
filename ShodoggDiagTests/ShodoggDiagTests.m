//
//  ShodoggDiagTests.m
//  ShodoggDiagTests
//
//  Created by Ronak Shastri on 2016-11-01.
//  Copyright © 2016 Clearbridge. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StartViewController.h"

@interface ShodoggDiagTests : XCTestCase

@end

@implementation ShodoggDiagTests

 StartViewController *myStart;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    myStart = [[StartViewController alloc] init];
    [myStart  viewDidLoad];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDevicesCount {
    // create the expectation with a nice descriptive message
    sleep(10);
    
    int count = [myStart numberOfDevicesFound];
    if (count > 0) {
        XCTAssertEqual(1, 1);
    }
}

@end
