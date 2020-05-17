//
//  SuggestionTablePresenter.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

protocol SuggestionsPresenterInterfaceProtocol {
    
    /// This method tells whether we can show suggestions or not.
    ///
    /// - Returns: a boolen value indicating whether or not we can show the suggestions.
    func canDisplaySuggestions() -> Bool
    
    /// This method makes the request to get  the suggestions saved in persistance.
    ///
    func getDataForSuggestions()
    
    /// This is the datasource method for view controller's tableView. This is called from tableview's method numberofRowsInSection. Method returns an integer value equal to number of rows in section.
    /// - Returns: an integer, which is the number of rows which has to be shown
     func numberOfRows() -> Int
     
    /// This is the datasource method for view controller's tableView. This is called from tableview's method cellforRowAtIndexPath. Method takes current index path as param and returns ImageModel to fill information on that cell.
    ///
    /// - Parameters:
    ///   - indexPath: index path of the cell for which cellForRow is called.
     func itemForRow(atIndexpath indexPath:IndexPath) -> String?
    
    /// This method is called user taps on a cell in tableview . Method takes indexpath and view  as parameter.
    ///
    /// - Parameters:
    ///   - atIndexpath: index path of the selected cell.
    ///   - view: Object of UIView which is used to show tableview .
    func didSelectRow(atIndexpath : IndexPath, view: UIView)
}

protocol SuggestionPresenterDelegate {
    /// This method tells the delegate the user have selected a suggestion and it passes the selected string to that view.
    ///
    /// - Parameters:
    ///   - suggestion: the search suggestion on which user have tapped.
    func didSelectSuggestion(suggestion: String)
}

class SuggestionTablePresenter: SuggestionsPresenterInterfaceProtocol {
    
    let interactor: SuggestionsInteractorInterfaceProtocol
    let delegate: SuggestionPresenterDelegate?
    
    private var suggestions = [String]()
    
    init(interactor: SuggestionsInteractorInterfaceProtocol, delegate: SuggestionPresenterDelegate?) {
        self.interactor = interactor
        self.delegate = delegate
        getDataForSuggestions()
        NotificationCenter.default.addObserver(self, selector: #selector(getDataForSuggestions), name: .SuggestionsUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .SuggestionsUpdated, object: nil)
    }
    
    //MARK: SuggestionsPresenterInterfaceProtocol methods
    func canDisplaySuggestions() -> Bool {
        return suggestions.count > 0
    }
    
    @objc func getDataForSuggestions() {
        suggestions = interactor.getData(for: Constants.persistanceKey)
    }
    
    func numberOfRows() -> Int {
        return suggestions.count
    }
    
    func didSelectRow(atIndexpath: IndexPath, view: UIView) {
        guard atIndexpath.row < suggestions.count  else {
            return
        }
        let suggestion = suggestions[atIndexpath.row]
        delegate?.didSelectSuggestion(suggestion: suggestion)
    }
    
    func itemForRow(atIndexpath indexPath: IndexPath) -> String? {
        let suggestion = suggestions[indexPath.row]
        return suggestion
    }
}
