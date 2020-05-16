//
//  AppBuilder.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

protocol AppBuilder {
    
    func getRootViewController() -> UINavigationController?
    
    func getDependencyForSuggestionsView(suggestionView: SuggestionsView) -> SuggestionsPresenterInterfaceProtocol
}

class Builder: AppBuilder {
    
    func getRootViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootController = storyboard.instantiateViewController(withIdentifier: "ImageSearchViewController") as? ImageSearchControllerInterfaceProtocol
        
        let apiTask = ImageAPITask(parser: ImageResponseParser(), url: ImageSearchAPI.imageSearchUrl)
        let persitanceTask = PersistanceTask()
        let interactor = ImageSearchInteractor(searchQueryTask: apiTask, persister:persitanceTask)
        let presenter = ImageSearchPresenter(searchInteractor: interactor)
        rootController?.searchPresenter = presenter
        rootController?.appBuilder = self

        if let rootVC = rootController {
         return UINavigationController(rootViewController: rootVC)
        }
        return nil
    }
    
    func getDependencyForSuggestionsView(suggestionView: SuggestionsView) -> SuggestionsPresenterInterfaceProtocol {
        let persister = PersistanceTask()
        let suggestionsInteractor = SuggestionsTableInteractor(persister: persister)
        let suggestionsPresenter = SuggestionTablePresenter(interactor: suggestionsInteractor, delegate: suggestionView)
        return suggestionsPresenter
    }
}
