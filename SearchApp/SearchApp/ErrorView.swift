//
//  ErrorView.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

struct ErrorStrings {
    static let somethingWentWrong = "Oops! Something went wrong. Our Great minds are working on it."
    static let noInternetError = "We had trouble reaching our servers. Pls check your internet connection."
}


class ErrorView: UIView {
    
    @IBOutlet var errorTextLbl: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(errorText: String = ErrorStrings.somethingWentWrong) {
        self.errorTextLbl.text = errorText
    }
    
}
