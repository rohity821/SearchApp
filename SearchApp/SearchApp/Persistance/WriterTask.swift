//
//  WriterTask.swift
//  TestApp
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
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
    
    /// A function that saves data into the persistant storage with the given key and value
    ///
    /// - Parameters:
    ///   - value: the value which has to be saved
    ///   - key: they key for which value has to be saved
    ///   - shouldAppend: whether or not to append the values into existing saved values
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
    
    private func writeData(searchResponse:[String], key:String) {
        if searchResponse.count == 0 {
            return
        }
        plistTask.writeSync(key: key, completion: { (value) -> AnyObject? in
            return NSKeyedArchiver.archivedData(withRootObject: searchResponse) as AnyObject
        })
        
        plistTask.tryExpnesiveWrite(expnesiveWrite: true)
    }
    
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
                writeData(searchResponse: savedResponse, key: key)
            }
        } else {
            writeData(searchResponse: [value], key: key)
        }
        NotificationCenter.default.post(name: .SuggestionsUpdated, object: nil)
    }
    
    func getDataForSuggestions(for key: String) -> [String]? {
        return readData(key:key)
    }
}
