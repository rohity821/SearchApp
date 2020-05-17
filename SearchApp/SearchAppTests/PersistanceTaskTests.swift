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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let persistanceTask =  PersistanceTask()
        persistanceTask.saveDataForSuggestions(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.contains("Facebook"), "Test case failed. Doesn't contain Facebook")
        }
        
        persistanceTask.saveDataForSuggestions(value: "Not Append", forKey: Constants.persistanceKey, shouldAppend: false)
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 1, "Test case failed. count is not 1")
        }
        
        persistanceTask.saveDataForSuggestions(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "Face", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "help", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "hey", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "Facelook", forKey: Constants.persistanceKey, shouldAppend: true)
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 6, "Test case failed. count is not 6")
            XCTAssert(savedKeys.contains("Face"), "Test case failed. Doesnot contain face")
            XCTAssert(savedKeys.contains("hey"), "Test case failed. Does not contain hey")
            XCTAssert(!savedKeys.contains("he"), "Test case failed. Does contain he")
        }
    }
    
    func testPersistance() {
        let persistanceTask = PersistanceTaskMock()
        persistanceTask.saveDataForSuggestions(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.contains("Facebook"), "Test case failed. Doesn't contain Facebook")
        }
        
        persistanceTask.saveDataForSuggestions(value: "Not Append", forKey: Constants.persistanceKey, shouldAppend: false)
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 1, "Test case failed. count is not 1")
        }
        
        persistanceTask.saveDataForSuggestions(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "Face", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "help", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "hey", forKey: Constants.persistanceKey, shouldAppend: true)
        persistanceTask.saveDataForSuggestions(value: "Facelook", forKey: Constants.persistanceKey, shouldAppend: true)
        if let savedKeys = persistanceTask.getDataForSuggestions(for: Constants.persistanceKey) {
            XCTAssert(savedKeys.count == 6, "Test case failed. count is not 6")
            XCTAssert(savedKeys.contains("Face"), "Test case failed. Doesnot contain face")
            XCTAssert(savedKeys.contains("hey"), "Test case failed. Does not contain hey")
            XCTAssert(!savedKeys.contains("he"), "Test case failed. Does contain he")
        }
    }

}
