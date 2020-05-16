//
//  DataManager.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation


protocol Persister {
    /**
     
     */
    func saveData(value:String, forKey key:String, shouldAppend:Bool)
    
    /**
    
    */
    func getDataForKey(key:String) -> [String]?
    
}
