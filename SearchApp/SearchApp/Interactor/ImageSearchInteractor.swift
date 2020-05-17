//
//  ImageSearchInteractor.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import Reachability

protocol ImageSearchInteractorDelegate {
    
    /// delegate method used to notify the class implementing it that the data is fetched. Result depends on the ResultType enum. if result is success, it will contain an object of image Response model. In case of error, it will have an error object
    ///
    /// - Parameters:
    ///   - result: ResultType enum. if result is success, it will contain an object of image Response model. In case of error, it will have an error object
    func didFetchPhotos(result: ResultType)
}

protocol ImageSearchInteractorInterfaceProtocol {
    
    
    var delegate : ImageSearchInteractorDelegate? { get set }
    
   /// Use this method to fetch results for users search query.
    ///
    /// - Parameters:
    ///   - searchQuery: The search query entered by user for searching.
    func getResultsForSearch(searchQuery:String)
    
    
    /// Use this method to get next page for your search query.
    ///
    /// - Parameters:
    ///   - searchQuery: The search query entered by user for searching.
    func getNextPageForSearch(searchQuery:String)
}

class ImageSearchInteractor: ImageSearchInteractorInterfaceProtocol  {
    
    var page : Int = 0
    var delegate : ImageSearchInteractorDelegate?
    
    let searchQueryTask: ImageAPITaskInterfaceProtocol
    let persister: Persister
    
    init(searchQueryTask: ImageAPITaskInterfaceProtocol, persister: Persister) {
        self.searchQueryTask = searchQueryTask
        self.persister = persister
    }
    
    func getResultsForSearch(searchQuery:String) {
        page = 1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    func getNextPageForSearch(searchQuery:String) {
        page = page+1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    //MARK: private functions
    private func getResultsForSearch(searchQuery:String, page:Int) {
        let finalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        if finalQuery.isEmpty {
            return
        }
        searchQueryTask.getSearchResults(searchTerm: finalQuery, page: page, onSuccess: { [weak self] (imageResponse) in
            if let imgModel = imageResponse {
                self?.delegate?.didFetchPhotos(result: .success(imageModel: imgModel))
                self?.persister.saveDataForSuggestions(value: finalQuery, forKey: Constants.persistanceKey, shouldAppend: true)
            }
        }) { [weak self] (error) in
            self?.delegate?.didFetchPhotos(result: .failure(error: SearchErrors.parsingError))
        }
    }
    
}
