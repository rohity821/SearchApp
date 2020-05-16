//
//  Constants.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation


enum SearchControllerState {
    case showResults
    case showSuggestions
    case showError(error: SearchErrors)
    case showEmptyScreen
    case showLoadingIndicator
}

struct Constants {
    static let cellIdentifier = "imageCell"
    static let placeholderImage = "placeholder"
    static let plistName = "SearchApp"
    static let persistanceKey = "SearchTerms"
    static let suggestionsCell = "suggestionsCell"
    static let searchBarPlaceholder = "Search Images"
    static let imagePreviewViewController = "ImagePreviewViewController"
    static let mainStoryboard = "Main"
}

enum SearchErrors: Error {
    case noInternet
    case parsingError
    case noData
    case empty
    
    public var errorDescription: String {
        switch self {
        case .noInternet:
            return ErrorStrings.noInternetError
        case .parsingError:
            return ErrorStrings.somethingWentWrong
        case .noData:
            return ErrorStrings.noResultsFound
        case .empty:
            return ErrorStrings.startSearching
        }
    }
    
}

enum ResultType {
    case success(imageModel: ImageResponseModel)
    case failure(error:SearchErrors?)
}
