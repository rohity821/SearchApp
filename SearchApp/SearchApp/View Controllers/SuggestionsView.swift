//
//  SuggestionsTableView.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit

protocol SuggestionsTableDelegate {
    func didSelectSuggestion(suggestions: String, for view:UIView)
}

protocol SuggestionsViewInterfaceProtocol {
    /// This method tells whether we can show suggestions or not.
    ///
    /// - Returns: a boolen value indicating whether or not we can show the suggestions.
    func canDisplaySuggestions() -> Bool
    
    /// This method makes the request to get  the suggestions saved in persistance. and reloads the table view
    ///
    func loadSuggestions()
}

class SuggestionsView: UIView, SuggestionPresenterDelegate {
    
    @IBOutlet var suggestionsTable: UITableView!
    var presenter: SuggestionsPresenterInterfaceProtocol?
    var delegate: SuggestionsTableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        suggestionsTable.delegate = self
        suggestionsTable.dataSource = self
        presenter?.getDataForSuggestions()
        suggestionsTable.tableFooterView = UIView()
    }
    
    //MARK: SuggestionsViewInterfaceProtocol methods
    func canDisplaySuggestions() -> Bool {
        return presenter?.canDisplaySuggestions() ?? false
    }
    
    func loadSuggestions() {
        presenter?.getDataForSuggestions()
        suggestionsTable.reloadData()
    }
    
    //MARK: SuggestionPresenterDelegate method
    func didSelectSuggestion(suggestion: String) {
        delegate?.didSelectSuggestion(suggestions: suggestion, for: self)
    }
}

extension SuggestionsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRows() ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: Constants.suggestionsCell,for: indexPath)
        let suggestion = presenter?.itemForRow(atIndexpath: indexPath)
        cell.textLabel?.text = suggestion
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(atIndexpath: indexPath, view: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
