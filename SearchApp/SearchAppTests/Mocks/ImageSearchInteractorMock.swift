//
//  ImageSearchInteractorMock.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
@testable import SearchApp
import XCTest

class ImageSearchInteractorMock: ImageSearchInteractorInterfaceProtocol {
    var delegate: ImageSearchInteractorDelegate?
    
    private var searchQuery: String?
    var getResultsForSearchCalled: Bool = false
    var getNextPageForSearchCalled: Bool = false
    var successDelegateFired: Bool = false
    
    func getResultsForSearch(searchQuery: String) {
        self.searchQuery = searchQuery
        getResultsForSearchCalled = true
        getMockData()
    }
    
    func getNextPageForSearch(searchQuery: String) {
        self.searchQuery = searchQuery
        getNextPageForSearchCalled = true
    }
    
    private func getMockData() {
        let JSON = try? JSONSerialization.jsonObject(with: stubbedResponse("Mock"), options: [])
        let completeJSON = JSON as? JSON
        let responseParser = ImageResponseParser()
        if let json = completeJSON, let data = jsonToData(json: json) {
            do {
                let parsedObject = try responseParser.parse(data: data)
                successDelegateFired = true
                delegate?.didFetchPhotos(result: .success(imageModel: parsedObject))
            } catch let error {
                debugPrint("Parsing failed \(error)")
                delegate?.didFetchPhotos(result: .failure(error: SearchErrors.parsingError))
            }
        }
    }
    
    func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject { }

        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json") ?? ""
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    
    func jsonToData(json: JSON) -> Data? {
        var data: Data? = nil
        do {
            data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
        } catch {
            debugPrint("errorParsing data")
        }
        return data
    }

}

