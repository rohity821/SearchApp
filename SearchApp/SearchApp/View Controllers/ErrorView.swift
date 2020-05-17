//
//  ErrorView.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorViewInterfaceProtocol : class {
    /// Call this function with specific error to display on screen.
    ///
    /// - Parameters:
    ///   - error: Type of SearchError, based on this the view error text is configured
    func configureErrorView(for error: SearchErrors?)
}

class ErrorView: UIView {
    
    @IBOutlet var errorTextLbl: UILabel!
    
    func configureErrorView(for error: SearchErrors?) {
        guard let error = error else {
            errorTextLbl.text = SearchErrors.parsingError.errorDescription
            return
        }
        errorTextLbl.text = error.errorDescription
    }
    
}
