//
//  ParserTest.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest
@testable import SearchApp

public typealias JSON = [String: AnyObject]

class ParserTest: XCTestCase {
    
    var completeJSON: JSON?
    
    override func setUp() {
        super.setUp()

        let JSON = try? JSONSerialization.jsonObject(with: stubbedResponse("Mock"), options: [])
        completeJSON = JSON as? JSON
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImageResponseParser() throws {
        let responseParser = ImageResponseParser()
        if let json = completeJSON, let data = jsonToData(json: json) {
            let parsedObject = try responseParser.parse(data: data)
            XCTAssertEqual(parsedObject.hits.count, 20)
            XCTAssertEqual(parsedObject.total, 160)
            
            
            let largeImageUrl = "https://pixabay.com/get/52e5d0424a52ae14f6da8c7dda79367e153dd6e753506c48702772d19545c650bc_1280.jpg"
            let id = 4551002
            let pageURL = "https://pixabay.com/photos/hello-baby-sank-fly-animal-nature-4551002/"
            let type = "photo"
            let userImageUrl = "https://cdn.pixabay.com/user/2019/09/04/05-59-04-223_250x250.jpg"
            let previewURL = "https://cdn.pixabay.com/photo/2019/10/15/08/02/hello-baby-4551002_150.jpg"
            let imageModel = ImageDataModel(largeImageURL: largeImageUrl, id: id, pageURL: pageURL, type: type, userImageURL: userImageUrl, previewURL: previewURL)
            XCTAssertEqual(parsedObject.hits.first, imageModel)
        }
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
