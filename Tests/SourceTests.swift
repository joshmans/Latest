//
//  SourceTests.swift
//  LatestTests
//

import XCTest
@testable import Latest

final class SourceTests: XCTestCase {
	
	func testOnlyAppStoreAndHomebrewAreBadgedInTheList() {
		XCTAssertTrue(App.Source.appStore.isBadgedInList)
		XCTAssertTrue(App.Source.homebrew.isBadgedInList)
		XCTAssertFalse(App.Source.sparkle.isBadgedInList)
		XCTAssertFalse(App.Source.none.isBadgedInList)
	}
	
	func testBadgedSourcesHaveAnIconAndName() {
		XCTAssertNotNil(App.Source.homebrew.sourceIcon)
		XCTAssertNotNil(App.Source.homebrew.sourceName)
		XCTAssertNotNil(App.Source.appStore.sourceName)
		// The App Store app ships with macOS.
		XCTAssertNotNil(App.Source.appStore.sourceIcon)
	}
	
	func testUnbadgedSourcesHaveNoIcon() {
		XCTAssertNil(App.Source.none.sourceIcon)
	}
	
}
