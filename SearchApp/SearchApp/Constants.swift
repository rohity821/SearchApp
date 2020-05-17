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
    static let noDataAlertTitle = "No Data found"
    static let okTitle = "OK"
}

extension NSNotification.Name {
    public static let SuggestionsUpdated = NSNotification.Name("suggestionsUpdated")
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

struct ErrorStrings {
    static let somethingWentWrong = "Oops! Something went wrong. Our Great minds are working on it."
    static let noInternetError = "We had trouble reaching our servers. Pls check your internet connection."
    static let startSearching = "Start searching from the search bar above and see a plethora of images."
    static let noResultsFound = "Looks like you have searched for something unique!"
}

enum ResultType {
    case success(imageModel: ImageResponseModel)
    case failure(error:SearchErrors?)
}
