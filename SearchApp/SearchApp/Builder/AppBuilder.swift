//
//  AppBuilder.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

struct AppBuilder {
    func getRootViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let rootController = storyboard.instantiateViewController(withIdentifier: "ImageSearchViewController") as? ImageSearchControllerInterfaceProtocol
        
        let apiTask = ImageAPITask(parser: ImageResponseParser(), url: ImageSearchAPI.imageSearchUrl)
        let interactor = ImageSearchInteractor(searchQueryTask: apiTask)
        let presenter = ImageSearchPresenter(searchInteractor: interactor)
        rootController?.searchPresenter = presenter

        if let rootVC = rootController {
         return UINavigationController(rootViewController: rootVC)
        }
        return nil
    }
}
