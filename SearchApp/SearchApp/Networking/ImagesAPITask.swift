//
//  ImagesAPITask.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import Keys

protocol ImageAPITaskInterfaceProtocol : class {
    /// Use this function to get the search results from network. This method requires search term and page as the api supports pagination. Returns success or failure based on the network result.
    ///
    /// - Parameters:
    ///   - searchTerm: the search term entered by user.
    ///   - page: the page which should be fetch. 1 if it is a fresh or new search and increased accordingly if any request is made for same search term.
    ///   - onSuccess: The completion block which will be called if the network call is successful and it will give object of ImageResponseModel.
    ///   - onFailure: the block which gets called when api calls fails due to any reason. Gives Error object.
    func getSearchResults(searchTerm: String, page:Int, onSuccess:@escaping (ImageResponseModel?)->Void, onFailure:@escaping (Error?)->Void)
}

class ImageAPITask : ImageAPITaskInterfaceProtocol {
    
    let keys = SearchAppKeys()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var parser: Parser
    var baseUrl: String
    
    init(parser: Parser, url: String) {
        self.parser = parser
        baseUrl = url
    }
    
    var imageResults: ImageResponseModel?
    
    let perPage = 30
    
    func getSearchResults(searchTerm: String, page:Int,onSuccess:@escaping (ImageResponseModel?)->Void, onFailure:@escaping (Error?)->Void) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: baseUrl) {
            urlComponents.query = "key=\(keys.pixabayApiKey)&image_type=photo&pretty=true&q=\(searchTerm)&per_page=\(perPage)&page=\(page)"
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
                defer { self?.dataTask = nil }
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let parsedModels = try self?.parser.parse(data: data)
                        onSuccess(parsedModels)
                    }
                    catch let parseError as NSError {
                        debugPrint("\(parseError)")
                        onFailure(error)
                        return
                    }
                } else {
                    debugPrint("\(String(describing: error))")
                    onFailure(error)
                }
            }
            dataTask?.resume()
        }
    }
}
