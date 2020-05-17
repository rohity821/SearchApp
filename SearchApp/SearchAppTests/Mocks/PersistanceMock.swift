//
//  PersistanceMock.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
@testable import SearchApp

class PersistanceTaskMock: Persister {
    var persistedDict = [String:[String]]()
    
    func saveData(value: String, forKey key: String, shouldAppend: Bool) {
        if shouldAppend {
            var array = getDataForKey(key: key) ?? []
            if !array.contains(value) {
                if array.count >= 10 {
                    array.removeFirst()
                }
                array.append(value)
                persistedDict[key] = array
            }
        } else {
            persistedDict[key] = [value]
        }
    }
    
    func getDataForKey(key: String) -> [String]? {
        return persistedDict[key]
    }
    
    
    func saveMockValues() {
        self.saveData(value: "Facebook", forKey: Constants.persistanceKey, shouldAppend: true)
        self.saveData(value: "Face", forKey: Constants.persistanceKey, shouldAppend: true)
        self.saveData(value: "help", forKey: Constants.persistanceKey, shouldAppend: true)
    }
    
}
