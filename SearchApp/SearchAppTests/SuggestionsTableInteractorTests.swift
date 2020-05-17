//
//  SuggestionsTableInteractorTests.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 17/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest
@testable import SearchApp

class SuggestionsTableInteractorTests: XCTestCase {


    func testSuggestionsInteractor() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let persister = PersistanceTaskMock()
        persister.saveMockValues()
        
        let interactor = SuggestionsTableInteractor(persister:persister)
        let data = interactor.getData(for: Constants.persistanceKey)
        XCTAssert(data.count == 3)
        XCTAssert(data.first == "Facebook")
    }


}
