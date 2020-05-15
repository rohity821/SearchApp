//
//  ImageSearchInteractor.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

enum SearchErrors: Error {
    case noInternet
    case parsingError
}

enum ResultType {
    case success(imageModel: ImageResponseModel)
    case failure(error:Error?)
}

protocol ImageSearchInteractorDelegate {
    /**
     delegate method used to notify the class implementing it that the data is fetched. Result depends on the ResultType enum. if result is success, it will contain an object of image Response model. In case of error, it will have an error object
     */
    func didFetchPhotos(result: ResultType)
}

protocol ImageSearchInteractorInterfaceProtocol {
    
    var delegate : ImageSearchInteractorDelegate? { get set }
    
    /**
           Add Documentation
    */
    func getResultsForSearch(searchQuery:String)
    
    /**
           Add Documentation
    */
    func getNextPageForSearch(searchQuery:String)
}

class ImageSearchInteractor : NSObject, ImageSearchInteractorInterfaceProtocol  {
    
    var page : Int = 0
    var delegate : ImageSearchInteractorDelegate?
    
    let searchQueryTask = ImageAPITask()
    
    
    func getResultsForSearch(searchQuery:String) {
        page = 1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    func getNextPageForSearch(searchQuery:String) {
        if !ReachabilityManager.shared.isNetworkReachable() {
            //It is returned because pagination wont work when network is not available.
            return
        }
        page = page+1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    private func getResultsForSearch(searchQuery:String, page:Int) {
        let finalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        if finalQuery.isEmpty {
            return
        }
        searchQueryTask.getSearchResults(searchTerm: finalQuery, page: page, onSuccess: { [weak self] (imageResponse) in
            //Handle Success
            if let imgModel = imageResponse {
                self?.delegate?.didFetchPhotos(result: .success(imageModel: imgModel))
            }
        }) { [weak self] (error) in
            //Handle Error
            self?.delegate?.didFetchPhotos(result: .failure(error: error))
        }
    }
    
}
