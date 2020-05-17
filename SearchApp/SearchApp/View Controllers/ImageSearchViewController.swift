//
//  ViewController.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Reachability

protocol ImageSearchControllerInterfaceProtocol where Self: UIViewController {
    
    var appBuilder: AppBuilder? { get set }
    var searchPresenter: ImageSearchPresenterInterfaceProtocol? { get set }
}

class ImageSearchViewController: UIViewController, ImageSearchControllerInterfaceProtocol {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var suggestionsView: SuggestionsView!
    private var reachability: Reachability?
    private var isReachable = true
    private var collectionDatasource: SearchCollectionDataSource?
    private var collectionDelegate: SearchCollectionDelegate?
    private var controllerState: SearchControllerState? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.configureViewAsPerState()
            }
        }
    }
    var searchPresenter: ImageSearchPresenterInterfaceProtocol?
    var appBuilder: AppBuilder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
        reachability = try Reachability()
        } catch {
            debugPrint("Error configuring reachability")
        }
        controllerState = .showEmptyScreen
        setupSearchBar()
        setupCollectionDatasourceDelegates()
        suggestionsView.presenter = appBuilder?.getDependencyForSuggestionsView(suggestionView: suggestionsView)
        suggestionsView.delegate = self
        searchPresenter?.presenterDelegate = self
    }
    
    /// Use this function to set the collection view datasource and delegates to different files. for collection view,  we are using SearchCollectionDataSource & SearchCollectionDelegate
    private func setupCollectionDatasourceDelegates() {
        guard let presenter = searchPresenter else {
            return
        }
        let collectionDatasource = SearchCollectionDataSource(presenter: presenter)
        imagesCollectionView.dataSource = collectionDatasource
        self.collectionDatasource = collectionDatasource
        
        let collectionDelegate = SearchCollectionDelegate(presenter: presenter, viewController: self)
        imagesCollectionView.delegate = collectionDelegate
        self.collectionDelegate = collectionDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
          try reachability?.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
    }
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    /// Notification observer for reachability change. use the notification according to your need.
    @objc func reachabilityChanged(note: Notification) {
        if let reachability = note.object as? Reachability {
            switch reachability.connection {
            case .wifi,.cellular:
                isReachable = true
            case .unavailable, .none:
                isReachable = false
            }
        }
    }
    
    //MARK: Private Functions
    /// This function configures the view as the current state of view controller stated by var controllerState. This methods decides which component to show based on the state.
    private func configureViewAsPerState() {
        guard let controllerState = controllerState else {
            return
        }
        switch controllerState {
        case .showEmptyScreen:
            showErrorView(error: .empty)
            hideLoadingIndicator()
            hideView(hideErrorView: false, hideSuggestionsView: true, hideColletionView: true)
        case .showError(let error):
            hideLoadingIndicator()
            showErrorView(error: error)
            hideView(hideErrorView: false, hideSuggestionsView: true, hideColletionView: true)
        case .showResults:
            hideLoadingIndicator()
            reloadCollectionView()
            hideView(hideErrorView: true, hideSuggestionsView: true, hideColletionView: false)
        case .showSuggestions:
            hideLoadingIndicator()
            reloadSuggestions()
            hideView(hideErrorView: true, hideSuggestionsView: false, hideColletionView:true)
        case .showLoadingIndicator:
            suggestionsView?.isHidden = true
            showLoadingIndicator()
        }
    }
    
    /// Call this funciton to hide or show the views available in the viewcontroller hierarchy.
    private func hideView(hideErrorView: Bool, hideSuggestionsView: Bool, hideColletionView: Bool) {
        errorView.isHidden = hideErrorView
        suggestionsView?.isHidden = hideSuggestionsView
        imagesCollectionView.isHidden = hideColletionView
    }
    
    /// This method configures and adds the search bar into the navigation item of navigation bar.
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    // This method configures the error view according to the type of error. If this method is not called on main thread, it recalls itself on main thread to ensure that all the view related functions or accessing the view is done on main thread to avoid any crashes.
    ///
    /// - Parameters:
    /// - error: Custom SearchErrors object that are available .
    private func showErrorView(error: SearchErrors?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.showErrorView(error: error)
            }
            return
        }
        errorView?.configureErrorView(for: error)
    }
    
    // This method reloads the collection view. If this method is not called on main thread, it recalls itself on main thread to ensure that all the view related functions or accessing the view is done on main thread to avoid any crashes.
    private func reloadCollectionView() {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCollectionView()
            }
            return
        }
        imagesCollectionView.reloadData()
    }
    
    // This method reloads the suggestion view. If there are no suggetions to display then it sets the controller state to show empty view. If this method is not called on main thread, it recalls itself on main thread to ensure that all the view related functions or accessing the view is done on main thread to avoid any crashes.
    private func reloadSuggestions() {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.reloadSuggestions()
            }
            return
        }
        if suggestionsView.canDisplaySuggestions() {
            suggestionsView?.loadSuggestions()
        } else {
            controllerState = .showEmptyScreen
        }
    }
    
    // This method inititates the search for the term user has entered. This methods checks if the network is reachable then only it sends the requests otherwise it just updates the view to show error screen.
    ///
    /// - Parameters:
    /// - searchText: the search text entered by user.
    private func startSearchFor(searchText: String) {
        if !isReachable {
            controllerState = .showError(error: .noInternet)
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchPresenter?.getDataWithSearchQuery(searchQuery: searchText)
    }
    
    // This method shows an alert for the error, when there is no data available. Although this has been handled by error screen also. But it was mentioned in the requirement docs to show an alert.
    ///
    /// - Parameters:
    /// - error: The SearchErrors object
    private func showAlert(error: SearchErrors) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showAlert(error: error)
            }
            return
        }
        if error == .noData {
            let alertController = UIAlertController(title: Constants.noDataAlertTitle, message: ErrorStrings.noResultsFound, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: Constants.okTitle, style: .destructive, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension ImageSearchViewController: ImageSearchPresenterDelegate, SuggestionsTableDelegate {
    func didFetchPhotos(result: ResultType) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        switch result {
        case .success(imageModel: _):
            controllerState = .showResults
        case .failure(let error):
            if let err = error {
                controllerState = .showError(error: err)
                // This is added to show an alert as the requirement was to show alert when there is no data. It has been  handled with Error Screen.
                showAlert(error: err)
            }
        }
    }
    
    func didSelectSuggestion(suggestions: String, for view: UIView) {
        dismissKeyboard()
        controllerState = .showLoadingIndicator
        startSearchFor(searchText: suggestions)
    }
}

extension ImageSearchViewController {
    //MARK: Loading Indicator
    /**
     This methods show blocking loading indicator on view.
    */
    private func showLoadingIndicator() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.showLoadingIndicator()
            }
            return
        }
        let activityData = ActivityData(size: nil, message: nil, messageFont: nil, messageSpacing: nil, type: .ballClipRotateMultiple, color: nil, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }
    
    /**
     This method hides loading indicator and ends refresh control animation whichever applicable, if it is not called on main thread it checks and call itself on main thread.
     */
    private func hideLoadingIndicator() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.hideLoadingIndicator()
            }
            return
        }
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
}

extension ImageSearchViewController : UISearchBarDelegate {

    /// Call this method to dismiss the keyboard
    @objc func dismissKeyboard() {
        navigationItem.searchController?.isActive = false
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            dismissKeyboard()
            controllerState = .showLoadingIndicator
            startSearchFor(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let presenter = searchPresenter {
            controllerState = presenter.canShowResults() ? .showResults : .showEmptyScreen
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        controllerState = .showSuggestions
    }
}
