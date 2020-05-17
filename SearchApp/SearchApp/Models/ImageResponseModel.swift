//
//  ImageModel.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

struct ImageResponseModel : Codable {
    
    let totalHits : Int?
    let hits : [ImageDataModel]
    var total : Int?
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct ImageDataModel : Codable, Equatable {
    let largeImageURL : String
    let id : Int
    let pageURL : String
    let type : String
    let userImageURL : String
    let previewURL : String
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    static func ==(lhs: ImageDataModel, rhs: ImageDataModel) -> Bool {
        return lhs.largeImageURL == rhs.largeImageURL && lhs.id == rhs.id && lhs.pageURL == rhs.pageURL && lhs.type == rhs.type && lhs.userImageURL == rhs.userImageURL && lhs.previewURL == rhs.previewURL
    }
}
