//
//  PersistanceTask.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

class PersistanceTask: Persister {
    
    let standardUserDefaults = UserDefaults.standard
    
    func saveData(value: String, forKey key: String, shouldAppend: Bool) {
        if shouldAppend {
            var array = getDataForKey(key: key) ?? []
            if !array.contains(value) {
                if array.count >= 10 {
                    array.removeFirst()
                }
                array.append(value)
                standardUserDefaults.set(array, forKey: key)
            }
        } else {
            standardUserDefaults.set(value, forKey: key)
        }
        standardUserDefaults.synchronize()
    }
    
    func getDataForKey(key: String) -> [String]? {
        return standardUserDefaults.array(forKey: key) as? [String]
    }
    
    
}
