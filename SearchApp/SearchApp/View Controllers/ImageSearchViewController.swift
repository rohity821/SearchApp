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

class ImageSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageSearchControllerInterfaceProtocol {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var suggestionsView: SuggestionsView!
    private var reachability: Reachability?
    private var isReachable = true
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
        suggestionsView.presenter = appBuilder?.getDependencyForSuggestionsView(suggestionView: suggestionsView)
        suggestionsView.delegate = self
        searchPresenter?.presenterDelegate = self
        showErrorView(error: .empty)
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
    
    private func hideView(hideErrorView: Bool, hideSuggestionsView: Bool, hideColletionView: Bool) {
        errorView.isHidden = hideErrorView
        suggestionsView?.isHidden = hideSuggestionsView
        imagesCollectionView.isHidden = hideColletionView
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    private func showErrorView(error: SearchErrors?) {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.showErrorView(error: error)
            }
            return
        }
        imagesCollectionView.isHidden = true
        errorView.isHidden = false
        errorView?.configureErrorView(for: error)
    }
    
    private func reloadCollectionView() {
        if !Thread.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCollectionView()
            }
            return
        }
        imagesCollectionView.reloadData()
    }
    
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
    
    private func sizeForItem(collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        let sidePadding : CGFloat = 8.0
        let noOfCells : CGFloat = 2
        let noOfPadding : CGFloat = noOfCells+1
        
        let itemW = (width - (noOfPadding * sidePadding))/noOfCells
        return CGSize(width: itemW, height: itemW)
    }
    
    private func startSearchFor(searchText: String) {
        if !isReachable {
            controllerState = .showError(error: .noInternet)
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        searchPresenter?.getDataWithSearchQuery(searchQuery: searchText)
    }

    //MARK: UICollectionView datasource & delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPresenter?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchPresenter?.numberOfSections(in: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell, let imageModel = searchPresenter?.itemForRow(atIndexpath: indexPath) {
            imageCell.setImage(imagePath: imageModel.previewURL)
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isReachable {
            return
        }
        searchPresenter?.fetchNextPageIfRequired(indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchPresenter?.didSelectRow(atIndexpath: indexPath, viewController: self)
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
