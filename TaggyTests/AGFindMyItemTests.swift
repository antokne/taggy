//
//  AGFindMyItemTests.swift
//  TaggyTests
//
//  Created by Antony Gardiner on 10/05/23.
//

import XCTest
@testable import Taggy

final class AGFindMyItemTests: XCTestCase {
	
	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testExample() throws {
		
		guard let url = Bundle(for: AGFindMyItemTests.self).url(forResource: "Items", withExtension: "data") else {
			XCTFail("Cannot load items file for test")
			return
		}
		
		
		let findMyItems = AGTagCollectorFindMyItems()
		
		let json = findMyItems.readFile(url: url)
		XCTAssertTrue(json?.count == 2)
		
		guard let json else {
			XCTFail("NO JSON")
			return
		}
		
		guard let jsonItem = json.first else {
			XCTFail("NO JSON")
			return
		}
		
		let item = AGFindMyItem(json: jsonItem)
		XCTAssertEqual(item.emojo, "🚲")
		XCTAssertEqual(item.roleName, "Bike")
		XCTAssertEqual(item.serialNumber, "HGDFVXZZP0GV")
		XCTAssertEqual(item.identifier?.uuidString, "20100704-6C60-4F9B-BB41-DFDBC654C6DA")

		XCTAssertEqual(item.latitude, -37.801710908108205)
		XCTAssertEqual(item.longitude, 175.29584023641735)
		XCTAssertEqual(item.horizontalAccuracy, 28.842722689970863)
		XCTAssertEqual(item.verticalAccuracy,  -1)


		XCTAssertEqual(item.name, "Ant’s Gravel Bike")
		
		
	}
	
	
	
}
