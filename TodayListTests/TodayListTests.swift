//
//  TodayListTests.swift
//  TodayListTests
//
//  Created by hula3 on 2018/3/2.
//  Copyright © 2018年 hula3. All rights reserved.
//

import XCTest
@testable import TodayList

class TodayListTests: XCTestCase {
    
    //MARK: Task Class Test
    
    // Confirm that the Task initializer returns a Task object when passed valid parameters.
    func testTaskInitializationSucceeds() {
        // Earliest
        
        // Latest
    }
    
    // Confirm that the Task initialier returns nil when passed an empty name.
    func testTaskInitializationFails() {
        // Empty String
        let emptyStringTask = Task.init(title: "", isChecked: false)
        XCTAssertNil(emptyStringTask)
        
        // isChecked
        let CheckedTask = Task.init(title: "sampleCheckedTask", isChecked: true)
        XCTAssertNil(CheckedTask)
    }
}
