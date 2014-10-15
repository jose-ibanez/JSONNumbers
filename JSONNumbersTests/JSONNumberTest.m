//
//  JSONNumberTest.m
//  JSONNumbers
//
//  Created by Ibanez, Jose on 10/14/14.
//  Copyright (c) 2014 CIM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface JSONNumberTest : XCTestCase

@end

@implementation JSONNumberTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInteger {
    NSNumber *originalNumber = [NSNumber numberWithInteger:42];
    NSLog(@"originalNumber [%@] objCType [%s]", originalNumber, originalNumber.objCType);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"deserializedJSONDictionary = %@", deserializedJSONDictionary);
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    NSLog(@"deserializedNumber [%@] objCType [%s]", deserializedNumber, deserializedNumber.objCType);
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode an integer");
}

- (void)testDouble {
    NSNumber *originalNumber = [NSNumber numberWithDouble:4.2];
    NSLog(@"originalNumber [%@] objCType [%s]", originalNumber, originalNumber.objCType);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"deserializedJSONDictionary = %@", deserializedJSONDictionary);
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    NSLog(@"deserializedNumber [%@] objCType [%s]", deserializedNumber, deserializedNumber.objCType);
    XCTAssert([originalNumber doubleValue] == [deserializedNumber doubleValue], @"deserialized number not equal");
    XCTAssert(strcmp(originalNumber.objCType, deserializedNumber.objCType) == 0, @"did not decode an float");
}

- (void)testLong {
    NSLog(@"long max = %ld", LONG_MAX);
    NSNumber *originalNumber = [NSNumber numberWithLong:LONG_MAX];
    NSLog(@"originalNumber [%@] objCType [%s]", originalNumber, originalNumber.objCType);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSLog(@"deserializedJSONDictionary = %@", deserializedJSONDictionary);
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    NSLog(@"deserializedNumber [%@] objCType [%s]", deserializedNumber, deserializedNumber.objCType);
    // fails on iOS 7 64 bit devices
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
    // passes on 32 bit device, fails on 64 bit device
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long");
}

- (void)testPowers {
    NSLog(@"long long max = %lld", LONG_LONG_MAX);
    for (int power = 0; power < 64; power++) {
        long long number = (long long)powl(2, power) - 1;
        NSNumber *originalNumber = [NSNumber numberWithLongLong:number];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
        NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];

        // passes on iOS 8, fails on iOS 7 when power > 59
        XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
        // always fails when power > 59
        XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long long");
    }
}

- (void)testTwoToTheFiftyNinthPower {
    int power = 59;
    long long number = (long long)powl(2, power) - 1;
    NSNumber *originalNumber = [NSNumber numberWithLongLong:number];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    
    // always passes
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long long");
}

- (void)testTwoToTheSixtiethPower {
    int power = 60;
    long long number = (long long)powl(2, power) - 1;
    NSNumber *originalNumber = [NSNumber numberWithLongLong:number];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    
    // fails
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long long");
    // passes on iOS 8, fails on iOS 7
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
}

- (void)testEighteenDigitNumber {
    long long number = (long long)999999999999999999;
    NSNumber *originalNumber = [NSNumber numberWithLongLong:number];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
    
    // passes
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long long");
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
}

- (void)testNineteenDigitNumber {
    long long number = (long long)1000000000000000000;
    NSNumber *originalNumber = [NSNumber numberWithLongLong:number];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
    NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];

    // fails
    XCTAssert(strcmp(deserializedNumber.objCType, @encode(long long)) == 0, @"did not decode a long long");
    // passes on iOS 8, fails on iOS 7
    XCTAssert([originalNumber longLongValue] == [deserializedNumber longLongValue], @"deserialized number not equal");
}

- (void)testMyPatience {
    long long min = 0x7ffffffffffffff;
    long long max = 0xfffffffffffffff;
    long long test;
    while (max > min) {
        test = ((max - min) / 2) + min;
        if (test == min || test == max) {
            // we're done
            break;
        }
        NSLog(@"test %llx", test);
        NSNumber *originalNumber = [NSNumber numberWithLongLong:test];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"number":originalNumber} options:0 error:nil];
        NSDictionary *deserializedJSONDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        NSNumber *deserializedNumber = deserializedJSONDictionary[@"number"];
        if (strcmp(deserializedNumber.objCType, @encode(long long)) == 0) {
            min = test;
        } else {
            max = test;
        }
    }
    NSLog(@"max passing value = %llX %llu, min failing value = %llX %llu", min, min, max, max);
}

@end
