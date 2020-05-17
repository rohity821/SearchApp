//
//  ImageSearchPresenterTests.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest
@testable import SearchApp

class ImageSearchPresenterTests: XCTestCase {

    let indexPathForNextPageCall = IndexPath(row: 19, section: 0)
    let indexPathForSecondCell = IndexPath(row: 1, section: 0)
    
    func testFetchData() {
        let mockInteractor = ImageSearchInteractorMock()
        let mockPresenter = ImageSearchPresenterMock(searchInteractor: mockInteractor)
        
        mockPresenter.getDataWithSearchQuery(searchQuery: "hello")
        XCTAssert(mockPresenter.getDataWithSearcQueryCalled)
        XCTAssert(mockInteractor.getResultsForSearchCalled)
        
        let items: Int = mockPresenter.numberOfItemsInSection(section: 1)
        XCTAssert(items == 20, "Test case failed. Count should be 20 but its \(items)")
        
        XCTAssert(mockPresenter.canShowResults())
        
        let secondItem: ImageDataModel? = mockPresenter.itemForRow(atIndexpath: indexPathForSecondCell)
        
        XCTAssert(secondItem?.id == 4477058)
        XCTAssert(secondItem?.largeImageURL == "https://pixabay.com/get/52e4d2444a57a414f6da8c7dda79367e153dd6e753506c48702772d19545c650bc_1280.jpg")
        XCTAssert(secondItem?.previewURL == "https://cdn.pixabay.com/photo/2019/09/14/23/14/dogs-4477058_150.jpg")
        
        mockPresenter.fetchNextPageIfRequired(indexPath: indexPathForNextPageCall)
        XCTAssert(mockPresenter.fetchNextpageCalled)
    }
    
}
