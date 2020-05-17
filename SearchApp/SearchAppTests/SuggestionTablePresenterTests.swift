//
//  SuggestionTablePresenterTests.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 17/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest
@testable import SearchApp

class SuggestionTablePresenterTests: XCTestCase {


    func testSuggestionPresenter() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let persistor = PersistanceTaskMock()
        persistor.saveMockValues()
        let interactor = SuggestionsTableInteractor(persister: persistor)
        let presenter = SuggestionTablePresenter(interactor: interactor, delegate: nil)
        
        XCTAssertTrue(presenter.canDisplaySuggestions())
        XCTAssert(presenter.numberOfRows() == 3)
        
        let item = presenter.itemForRow(atIndexpath: IndexPath(row: 1, section: 0))
        XCTAssertEqual(item, "Face")
    }

}
