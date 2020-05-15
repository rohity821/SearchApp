//
//  ImageSearchPresenter.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

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
    func numberOfItemsInSection(section: Int) -> Int
    
    /**
           Add Documentation
    */
    func numberOfSections(in collectionView: UICollectionView) -> Int
     
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
        clearPreviousData()
        self.searchQuery = searchQuery
        searchInteractor?.getResultsForSearch(searchQuery: searchQuery)
    }
    
    func getNextPage() {
        if searchQuery.isEmpty {
            return
        }
        searchInteractor?.getNextPageForSearch(searchQuery: searchQuery)
    }
    
    private func clearPreviousData() {
        searchQuery = ""
        imagesArray.removeAll()
    }
    
    //Mark : ImageSearchInteractorDelegate
    func didFetchPhotos(result: ResultType) {
        switch result {
        case .success(imageModel: let model):
            if imagesArray.count > 0 {
                imagesArray += model.hits
            }
            else {
                imagesArray = model.hits
            }
            if imagesArray.isEmpty {
                presenterDelegate?.didFetchPhotos(result: .failure(error: SearchErrors.noData))
                return
            }
        case .failure(let error):
            print("error occured \(String(describing: error))")
        }
        presenterDelegate?.didFetchPhotos(result: result)
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return imagesArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func itemForRow(atIndexpath indexPath: IndexPath) -> ImageDataModel? {
        var imgModel : ImageDataModel?
        if (indexPath.row < imagesArray.count) {
            imgModel = imagesArray[indexPath.row]
        }
        return imgModel
    }
    
    func fetchNextPageIfRequired(indexPath: IndexPath) {
        if indexPath.row == imagesArray.count-2 {
            getNextPage()
        }
    }
    
    func didSelectRow(atIndexpath: IndexPath, viewController: ImageSearchViewController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let destinationController = storyboard.instantiateViewController(withIdentifier: "ImagePreviewViewController") as? ImagePreviewInterfaceProtocol {
            destinationController.setImages(images:imagesArray, with: atIndexpath.row)
            viewController.navigationController?.pushViewController(destinationController, animated: true)
        }
    }
}
