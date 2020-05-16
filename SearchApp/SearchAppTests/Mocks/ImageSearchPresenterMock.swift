//
//  ImageSearchPresenterMock.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit
@testable import SearchApp

class ImageSearchPresenterMock: ImageSearchPresenterInterfaceProtocol, ImageSearchInteractorDelegate {
    
    var presenterDelegate: ImageSearchPresenterDelegate?
    var searchInteractor: ImageSearchInteractorInterfaceProtocol?
    
    private var imageResponseModel: ImageResponseModel?
    
    var getDataWithSearcQueryCalled = false
    var didSelectItemCalled = false
    var fetchError:Result<Any, SearchErrors>?
    var fetchNextpageCalled = false
    
    func getDataWithSearchQuery(searchQuery: String) {
        getDataWithSearcQueryCalled = true
        searchInteractor?.getResultsForSearch(searchQuery: searchQuery)
    }
    
    init(searchInteractor : ImageSearchInteractorInterfaceProtocol) {
        self.searchInteractor = searchInteractor
        self.searchInteractor?.delegate = self;
    }
    
    func canShowResults() -> Bool {
        if let responseModel = imageResponseModel {
            return responseModel.hits.count > 0
        }
        return false
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        if let responseModel = imageResponseModel {
            return responseModel.hits.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func itemForRow(atIndexpath indexPath: IndexPath) -> ImageDataModel? {
        if let responseModel = imageResponseModel, indexPath.row < responseModel.hits.count {
            let imageModel = responseModel.hits[indexPath.row]
            return imageModel
        }
        return nil
    }
    
    func didSelectRow(atIndexpath: IndexPath, viewController: UIViewController) {
    }
    
    func fetchNextPageIfRequired(indexPath: IndexPath) {
        fetchNextpageCalled = true
    }
    
    func didFetchPhotos(result: ResultType) {
        switch result {
        case .success(imageModel: let imageModel):
            imageResponseModel = imageModel
        case .failure(error: let error):
            fetchError = .failure(error ?? .parsingError)
        }
    }
}

