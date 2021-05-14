//
//  SwannTests.swift
//  SwannTests
//
//  Created by sid on 14/5/21.
//

import XCTest
@testable import Swann

class SwannTests: XCTestCase {

    func testFetchStreams() throws {
        
        let expectation = self.expectation(description: "fetch streams")
        StreamManager.shared.fetchStreams { streamObject, error in
            assert(error == nil, "Error should be nil")
            assert(streamObject?.streams.count == 3, "Screens should be 3")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 20)
    }

}
