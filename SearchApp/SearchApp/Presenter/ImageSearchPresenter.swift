//
//  ImageSearchPresenter.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol ImageSearchPresenterInterfaceProtocol {
    
    /**
            Add Documentation
     */
    func getDataWithSearchQuery(searchQuery:String)
    
    /**
           Add Documentation
    */
    func getNextPage()
    
    /**
      This is the datasource method for view controller's tableView. This is called from tableview's method numberofRowsInSection. Method returns an integer value equal to number of rows in section.
      */
     func numberOfRows() -> Int
     
     /**
      This is the datasource method for view controller's tableView. This is called from tableview's method cellforRowAtIndexPath. Method takes current index path as param and returns ImageModel to fill information on that cell.
      */
     func itemForRow(atIndexpath indexPath:IndexPath) -> ImageDataModel?
    
     /**
      This method is called user taps on a cell in tableview. Method takes indexpath and view controller as parameter. And correspondingly navigates to another view.
      */
     func didSelectRow(atIndexpath : IndexPath, viewController:ImageSearchViewController)
}

protocol ImageSearchPresenterDelegate {
    /**
     delegate method used to notify the class implementing it that the data is fetched. Result depends on the ResultType enum. if result is success, it will contain an object of image response model. In case of error, it will have an error object
     */
    func didFetchPhotos(result: ResultType)
}

class ImageSearchPresenter :ImageSearchPresenterInterfaceProtocol, ImageSearchInteractorDelegate {
    
    var presenterDelegate : ImageSearchPresenterDelegate?
    var searchInteractor: ImageSearchInteractorInterfaceProtocol?
    var searchQuery = ""
    private var imagesArray = [ImageDataModel]()
    
    init(searchInteractor : ImageSearchInteractorInterfaceProtocol) {
        self.searchInteractor = searchInteractor
        self.searchInteractor?.delegate = self;
    }
    
    func getDataWithSearchQuery(searchQuery: String) {
        self.searchQuery = searchQuery
        searchInteractor?.getResultsForSearch(searchQuery: searchQuery)
    }
    
    func getNextPage() {
        if searchQuery.isEmpty {
            return
        }
        searchInteractor?.getNextPageForSearch(searchQuery: searchQuery)
    }
    
    //Mark : ImageSearchInteractorDelegate
    func didFetchPhotos(result: ResultType) {
        switch result {
        case .success(imageModel: let model):
            imagesArray = model.hits
        case .failure(let error):
            print("error occured \(String(describing: error))")
        }
        presenterDelegate?.didFetchPhotos(result: result)
    }
    
    func numberOfRows() -> Int {
        return imagesArray.count
    }
    
    func itemForRow(atIndexpath indexPath: IndexPath) -> ImageDataModel? {
        var imgModel : ImageDataModel?
        if (indexPath.row < imagesArray.count) {
            imgModel = imagesArray[indexPath.row]
        }
        return imgModel
    }
    
    func didSelectRow(atIndexpath: IndexPath, viewController: ImageSearchViewController) {
        //TODO: Add implementation
    }
}
