import XCTest
@testable import JSQMessagesSwift

class JSQMessagesSwiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(JSQMessagesSwift().text, "Hello, World!")
    }


    static var allTests : [(String, (JSQMessagesSwiftTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
