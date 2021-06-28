//
//  eCommunicationBookTests.swift
//  eCommunicationBookTests
//
//  Created by Jade Chiang on 2021/6/20.
//  Copyright © 2021 TKY co. All rights reserved.
//

import XCTest
@testable import eCommunicationBook

// swiftlint:disable implicitly_unwrapped_optional
class eCommunicationBookTests: XCTestCase {
    
    var sut: AttendanceSheetViewModel!
    
    override func setUpWithError() throws {
        
        try super.setUpWithError()
        
        sut = AttendanceSheetViewModel()
    }
    
    override func tearDownWithError() throws {
        
        sut = nil
    }
    
    func testExample() throws {

    }
    
    func testPerformanceExample() throws {
        measure {

        }
    }
    
    func testCalculateAttendanceRate() {
        // given
        let columns = ["", "", "", "", ""]
        let guessRow = [["A", "❌", "❌", "❌"],
                        ["B", "✅", "✅", "✅"],
                        ["C", "☑️", "☑️", "☑️"],
                        ["D", "❌", "✅", "☑️"]]
        sut.columns = columns
        sut.rows = guessRow
        
        // when
        sut.calculateAttendanceRate()
        
        // then
        XCTAssertEqual(sut.rows[0][4], "0.0%", "Rate computed from guessRows is wrong")
        XCTAssertEqual(sut.rows[1][4], "100.0%", "Rate computed from guessRows is wrong")
        XCTAssertEqual(sut.rows[2][4], "50.0%", "Rate computed from guessRows is wrong")
        XCTAssertEqual(sut.rows[3][4], "50.0%", "Rate computed from guessRows is wrong")
    }
}
