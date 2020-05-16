//
//  SuggestionsTableInteractor.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol SuggestionsInteractorInterfaceProtocol {
    /// This method is used to get data from the persister about the suggestions stored.
    ///
    /// - Parameters:
    ///   - key: the key for which the suggestions are stored in persistance.
    /// - Returns: [String] - this method returns an array of string values that are the previous 10 suggestions from user's sucessful search.
    func getData(for key:String) -> [String]
}

class SuggestionsTableInteractor: SuggestionsInteractorInterfaceProtocol {
    
    let persister: Persister
    
    init(persister: Persister) {
        self.persister = persister
    }
    
    func getData(for key: String) -> [String] {
        return persister.getDataForKey(key: key) ?? []
    }
    
    
}
