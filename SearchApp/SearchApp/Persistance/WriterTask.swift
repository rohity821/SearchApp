//
//  WriterTask.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

class WriterTask : NSObject, Persister {
    private static var sharedManager: WriterTask = WriterTask()
    
    private  let plistExtension = ".plist"
    
    private override init() {}
    
    class func shared() -> WriterTask {
        return sharedManager
    }
    
    private lazy var plistTask : ThreadSafePlistTask = {
        let plistName = "/"+"SearchApp"+plistExtension
        let plistPath = getCacheDataDirectory().appendingFormat(plistName)
        let dataPlist = ThreadSafePlistTask(plistPath: plistPath, writeFrequency: ThreadSafePlistWriteFrequency.normal)
        return dataPlist
    }()
    
    /// Use this function to get the cache directory for saving the plist file
    ///
    /// - Returns: the path to Data folder inside cache directory. Data folder was created to save the plist file
    ///
    private func getCacheDataDirectory() -> String {
        let path : String = ((NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]) as String)
        let destPath : String = path.appending("/Data")
        if !FileManager.default.fileExists(atPath: destPath) {
            do {
                try FileManager.default.createDirectory(atPath: destPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("\(error.localizedDescription)")
            }
        }
        return destPath
    }
    
    /// Use this function to write data in plist for corresponding key
    ///
    /// - Parameters:
    ///   - searchQuery: an array of string which has to be saved in the file for given key
    ///   - key: they key for which value has to be saved
    private func writeData(searchQuery:[String], key:String) {
        if searchQuery.count == 0 {
            return
        }
        plistTask.writeSync(key: key, completion: { (value) -> AnyObject? in
            return NSKeyedArchiver.archivedData(withRootObject: searchQuery) as AnyObject
        })
        
        plistTask.tryExpnesiveWrite(expnesiveWrite: true)
    }
    
    /// Use this function to read data from plist for corresponding key
    ///
    /// - Parameters:
    ///   - key: they key for which value has to be read
    private func readData(key: String) -> [String]? {
        if let tValue = plistTask.valueForKey(key: key) as? Data, let responseArray = NSKeyedUnarchiver.unarchiveObject(with: tValue) as? Array<String> {
            return responseArray
        }
        return nil
    }

    func saveDataForSuggestions(value:String, forKey key:String, shouldAppend:Bool) {
        if value.isEmpty {
            return
        }
        if var savedResponse = getDataForSuggestions(for: key), shouldAppend {
            if !savedResponse.contains(value) {
                if savedResponse.count >= 10 {
                    savedResponse.removeFirst()
                }
                savedResponse.append(value)
                writeData(searchQuery: savedResponse, key: key)
            }
        } else {
            writeData(searchQuery: [value], key: key)
        }
        NotificationCenter.default.post(name: .SuggestionsUpdated, object: nil)
    }
    
    func getDataForSuggestions(for key: String) -> [String]? {
        return readData(key:key)
    }
}
