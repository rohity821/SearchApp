//
//  PersistanceTaskTests.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest
@testable import SearchApp

class PersistanceTaskTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let persistanceTask =  PersistanceTask()
        persistanceTask.saveData(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        
        if let savedKeys = persistanceTask.getDataForKey(key: Constants.persistanceKey) {
            XCTAssert(savedKeys.contains("Facebook"), "Test case failed. Doesn't contain Facebook")
        }
        
        persistanceTask.saveData(value: "Not Append", forKey: Constants.persistanceKey, shouldAppend: false)
        if let savedKeys = persistanceTask.getDataForKey(key: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 1, "Test case failed. count is not 1")
        }
        
        persistanceTask.saveData(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveData(value: "Face", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveData(value: "help", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveData(value: "hey", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveData(value: "Facelook", forKey: Constants.persistanceKey, shouldAppend: true)
        if let savedKeys = persistanceTask.getDataForKey(key: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 6, "Test case failed. count is not 6")
            XCTAssert(savedKeys.contains("Face"), "Test case failed. Doesnot contain face")
            XCTAssert(savedKeys.contains("hey"), "Test case failed. Does not contain hey")
            XCTAssert(!savedKeys.contains("he"), "Test case failed. Does contain he")
        }
        
    }

}
