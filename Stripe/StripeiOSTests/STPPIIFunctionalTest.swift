//  Converted to Swift 5.8.1 by Swiftify v5.8.28463 - https://swiftify.com/
//
//  STPPIIFunctionalTest.swift
//  Stripe
//
//  Created by Charles Scalesse on 1/8/17.
//  Copyright © 2017 Stripe, Inc. All rights reserved.
//

import StripeCoreTestUtils
import XCTest

class STPPIIFunctionalTest: XCTestCase {
    func testCreatePersonallyIdentifiableInformationToken() {
        let client = STPAPIClient(publishableKey: STPTestingDefaultPublishableKey)

        let expectation = self.expectation(description: "PII creation")

        client.createToken(withPersonalIDNumber: "0123456789") { token, error in
            expectation.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(Int(token ?? 0))
            XCTAssertNotNil(token?.tokenId ?? 0)
            XCTAssertEqual(token?.type ?? 0, Int(STPTokenTypePII))
        }

        waitForExpectations(timeout: TestConstants.stpTestingNetworkRequestTimeout, handler: nil)
    }

    func testSSNLast4Token() {
        let client = STPAPIClient(publishableKey: STPTestingDefaultPublishableKey)

        let expectation = self.expectation(description: "PII creation")

        client.createToken(withSSNLast4: "1234") { token, error in
            expectation.fulfill()
            XCTAssertNil(error)
            XCTAssertNotNil(Int(token ?? 0))
            XCTAssertNotNil(token?.tokenId ?? 0)
            XCTAssertEqual(token?.type ?? 0, Int(STPTokenTypePII))
        }

        waitForExpectations(timeout: TestConstants.stpTestingNetworkRequestTimeout, handler: nil)
    }
}