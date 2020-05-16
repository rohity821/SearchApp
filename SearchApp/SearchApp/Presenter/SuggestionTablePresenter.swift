//
//  SuggestionTablePresenter.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol SuggestionsPresenterInterfaceProtocol {
    
    func canDisplaySuggestions() -> Bool
    
    func getDataForSuggestions()
    
    /**
      This is the datasource method for view controller's tableView. This is called from tableview's method numberofRowsInSection. Method returns an integer value equal to number of rows in section.
      */
     func numberOfRows() -> Int
     
     /**
      This is the datasource method for view controller's tableView. This is called from tableview's method cellforRowAtIndexPath. Method takes current index path as param and returns ImageModel to fill information on that cell.
      */
     func itemForRow(atIndexpath indexPath:IndexPath) -> String?
    
     /**
      This method is called user taps on a cell in tableview. Method takes indexpath and view controller as parameter. And correspondingly navigates to another view.
      */
    func didSelectRow(atIndexpath : IndexPath, view:SuggestionsView)
}

protocol SuggestionPresenterDelegate {
    func didSelectSuggestion(suggestion: String)
}

class SuggestionTablePresenter: SuggestionsPresenterInterfaceProtocol {
    
    let interactor: SuggestionsInteractorInterfaceProtocol
    let delegate: SuggestionPresenterDelegate?
    
    private var suggestions = [String]()
    
    init(interactor: SuggestionsInteractorInterfaceProtocol, delegate: SuggestionPresenterDelegate) {
        self.interactor = interactor
        self.delegate = delegate
        getDataForSuggestions()
    }
    
    func canDisplaySuggestions() -> Bool {
        return suggestions.count > 0
    }
    
    func getDataForSuggestions() {
        suggestions = interactor.getData(for: Constants.persistanceKey)
    }
    
    func numberOfRows() -> Int {
        return suggestions.count
    }
    
    func didSelectRow(atIndexpath: IndexPath, view: SuggestionsView) {
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
