//
//  ImageSearchInteractorTests.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest

class ImageSearchInteractorTests: XCTestCase {

    let indexPathForNextPageCall = IndexPath(row: 19, section: 0)
    let indexPathForSecondCell = IndexPath(row: 1, section: 0)
    
    func testFetchData() {
        let mockInteractor = ImageSearchInteractorMock()
        mockInteractor.getResultsForSearch(searchQuery: "hello")
        XCTAssert(mockInteractor.getResultsForSearchCalled)
        mockInteractor.getNextPageForSearch(searchQuery: "hello")
        XCTAssert(mockInteractor.getNextPageForSearchCalled)
        XCTAssert(mockInteractor.successDelegateFired)
    }

}
