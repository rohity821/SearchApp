//
//  Parser.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol Parser {
    /// This function parse the given data into ImageResponseModel and throws a error if it fails to do so.
    ///
    /// - Parameters:
    ///   - data: Object of Data Type, mostly network response data.
    ///
    /// - Returns: ImageResponseModel object, which contains the ImageDataModel objects and other neccessary information.
    func parse(data: Data) throws -> ImageResponseModel
}

struct ImageResponseParser: Parser {
    func parse(data: Data) throws -> ImageResponseModel {
        let decoder = JSONDecoder()
        let parsedModels = try decoder.decode(ImageResponseModel.self, from: data)
        return parsedModels
    }
}
