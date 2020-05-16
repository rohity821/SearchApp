//
//  DataManager.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation


protocol Persister {
    
    /// A function that saves data into the persistant storage with the given key and value
    ///
    /// - Parameters:
    ///   - value: the value which has to be saved
    ///   - key: they key for which value has to be saved
    ///   - shouldAppend: whether or not to append the values into existing saved values
    /// - Returns: nil
    func saveData(value:String, forKey key:String, shouldAppend:Bool)
    
    /// A function that gets all the saved values for a given key from persistance
    ///
    /// - Parameters:
    ///   - key: they key for which value has to be fetched
    /// - Returns: Array of strings, all the values which are stored.
    func getDataForKey(key:String) -> [String]?
    
}
