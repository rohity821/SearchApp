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
    
    func setupImage(imagePath: String)
}

class PageContentView: UIViewController, PageContentViewInterfaceProtocol {
    
    @IBOutlet var imageView: UIImageView!
    var index: Int?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.bounds
    }
    
    func setupImage(imagePath: String) {
        let url = URL(string: imagePath)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
}
