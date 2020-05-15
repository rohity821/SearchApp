//
//  ImagesAPITask.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation

protocol ImageAPITaskInterfaceProtocol : class {
    func getSearchResults(searchTerm: String, page:Int, onSuccess:@escaping (ImageResponseModel?)->Void, onFailure:@escaping (Error?)->Void)
}

class ImageAPITask : ImageAPITaskInterfaceProtocol {
    
    let apiKey = "10028201-f7ffd1c4b91bb9627b124a7b9"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var imageResults: ImageResponseModel?
    
    let perPage = 40
    
    func getSearchResults(searchTerm: String, page:Int,onSuccess:@escaping (ImageResponseModel?)->Void, onFailure:@escaping (Error?)->Void) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: ImageSearchAPI.imageSearchUrl) {
            urlComponents.query = "key=\(apiKey)&image_type=photo&pretty=true&q=\(searchTerm)&per_page=\(perPage)&page=\(page)"
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                    let decoder = JSONDecoder()
                    let parsedModels = try decoder.decode(ImageResponseModel.self, from: data)
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
