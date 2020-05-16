//
//  SuggestionsTableInteractor.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol SuggestionsInteractorInterfaceProtocol {
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
