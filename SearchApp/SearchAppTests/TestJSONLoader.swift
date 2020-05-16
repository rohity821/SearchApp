//
//  TestJSONLoader.swift
//  SearchAppTests
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import XCTest

extension XCTestCase {

    func jsonForName(name: String) -> JSON {
        guard let data = stubbedResponse(name) else { return [:] }

        do {
            guard let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                XCTFail("Nil JSON")
                return [:]
            }
            return JSON
        } catch {
            XCTFail("\(error.localizedDescription)")
            return [:]
        }
    }

    func jsonArrayForName(name: String) -> [JSON] {
        guard let data = stubbedResponse(name) else { return [] }
        do {
            guard let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? [JSON] else {
                XCTFail("Nil JSON")
                return []
            }
            return JSON
        } catch {
            XCTFail("\(error.localizedDescription)")
            return []
        }
    }

    func jsonFor(data: Data) -> JSON {
        do {
            guard let JSON = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                XCTFail("Nil JSON")
                return [:]
            }
            return JSON
        } catch {
            XCTFail("\(error.localizedDescription)")
            return [:]
        }
    }

    func stubbedResponse(_ filename: String) -> Data! {
        @objc class TestClass: NSObject { }

        let bundle = Bundle(for: TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json") ?? ""
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
}
