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
    static let startSearching = "Start searching from the search bar above and see a plethora of images."
    static let noResultsFound = "Looks like you have searched for something unique!"
}

protocol ErrorViewInterfaceProtocol : class {
    func configureErrorView(for error: SearchErrors?)
}

class ErrorView: UIView {
    
    @IBOutlet var errorTextLbl: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureErrorView(for error: SearchErrors?) {
        guard let error = error else {
            errorTextLbl.text = ErrorStrings.somethingWentWrong
            return
        }
        errorTextLbl.text = error.errorDescription
    }
    
}
