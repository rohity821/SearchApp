//
//  ImageCollectionViewCell.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit
import Kingfisher


class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(imagePath:String) {
        let url = URL(string: imagePath)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url, options: [.transition(.fade(0.2))])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: Constants.placeholderImage)
    }
}
