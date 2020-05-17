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
    
    var presenterDelegate : ImageSearchPresenterDelegate? { get set }
    
    /// Use this method to perform the fetch request for search query entered by user.
    ///
    /// - Parameters:
    ///   - searchQuery: the term/image/query that user wants to search.
    func getDataWithSearchQuery(searchQuery:String)
    
    /// This method tells the caller that the viewcontroller can show the results from previously fetched query, in case something went wrong with current query.
    ///
    /// - Returns: bool indicating if it is capable of showing results from previous search query.
    func canShowResults() -> Bool
    
    /// This is the datasource method for view controller's CollectionView. This is called from collectionView's method numberOfItemsInSection. Method returns an integer value equal to number of rows in section.
    ///
    /// - Parameters:
    ///   - section: the section for which the number of items has to be defined.
    func numberOfItemsInSection(section: Int) -> Int
    
    /// This is the datasource method for view controller's Collectionview. This method defines how many sections will be there in the collection view.
    ///
    /// - Parameters:
    ///   - collectionView: collectionView object for whom this delegate is being called.
    func numberOfSections(in collectionView: UICollectionView) -> Int
     
    /// This is the datasource method for view controller's Collectionview. This is called from collectionView''s method cellForItemAt. Method takes current index path as param and returns ImageModel to fill information on that cell.
    ///
    /// - Parameters:
    ///   - indexPath: Indexpath of the current cell for  whom cellForItemAt is being called.
    func itemForRow(atIndexpath indexPath:IndexPath) -> ImageDataModel?
    
    /// This method is called user taps on a cell in collectionView. Method takes indexpath and view controller as parameter. And correspondingly navigates to another view.
    ///
    /// - Parameters:
    ///   - indexPath: Indexpath of the cell on which the tap have happened.
    ///   - viewController: viewController which has to be used for navigating to next view for displaying images.
    func didSelectRow(atIndexpath: IndexPath, viewController: UIViewController)
    
    /// This method is used to fetch next page when user have scrolled till last - 2 index of the collection view.
    ///
    /// - Parameters:
    ///   - indexPath: Indexpath of the current cell for which willDisplayCell must have been called from collectionview.
    func fetchNextPageIfRequired(indexPath: IndexPath)
}

protocol ImageSearchPresenterDelegate {
    /// delegate method used to notify the class implementing it that the data is fetched. Result depends on the ResultType enum. if result is success, it will contain an object of image Response model. In case of error, it will have an error object
    ///
    /// - Parameters:
    ///   - result: ResultType enum. if result is success, it will contain an object of image Response model. In case of error, it will have an error object
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
    
    //MARK: Private helper functions
    private func clearPreviousData() {
        searchQuery = ""
        imagesArray.removeAll()
    }
    
    // this method is responsible for fetching the next page if search query is not empty.
    private func getNextPage() {
        if searchQuery.isEmpty {
            return
        }
        searchInteractor?.getNextPageForSearch(searchQuery: searchQuery)
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
    
    //MARK: ImageSearchPresenterInterfaceProtocol
    func getDataWithSearchQuery(searchQuery: String) {
        clearPreviousData()
        self.searchQuery = searchQuery
        searchInteractor?.getResultsForSearch(searchQuery: searchQuery)
    }
    
    func canShowResults() -> Bool {
        return imagesArray.count > 0
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
    
    func didSelectRow(atIndexpath: IndexPath, viewController: UIViewController) {
        let storyboard = UIStoryboard(name: Constants.mainStoryboard, bundle: nil)
        if let destinationController = storyboard.instantiateViewController(withIdentifier: Constants.imagePreviewViewController) as? ImagePreviewInterfaceProtocol {
            destinationController.setImages(images:imagesArray, with: atIndexpath.row)
            viewController.navigationController?.pushViewController(destinationController, animated: true)
        }
    }
}
