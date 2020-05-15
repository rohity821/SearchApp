//
//  Parser.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol Parser {
    func parse(data: Data) throws -> ImageResponseModel
}

struct ImageResponseParser: Parser {
    func parse(data: Data) throws -> ImageResponseModel {
        let decoder = JSONDecoder()
        let parsedModels = try decoder.decode(ImageResponseModel.self, from: data)
        return parsedModels
    }
}
