//
//  PageContentView.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit
import Kingfisher

protocol PageContentViewInterfaceProtocol where Self: UIViewController {
    
    var index: Int? { get set}
    var imagePath: String? { get set }
}

class PageContentView: UIViewController, PageContentViewInterfaceProtocol {
    
    @IBOutlet var imageView: UIImageView!
    var index: Int?
    var imagePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageStr = imagePath {
            setupImage(imagePath: imageStr)
        }
    }
    
    private func setupImage(imagePath: String) {
        let url = URL(string: imagePath)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
}
