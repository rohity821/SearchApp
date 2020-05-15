//
//  ViewController.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var errorView: ErrorView!
    @IBOutlet var imagesCollectionView: UICollectionView!
    
    var searchPresenter = ImageSearchPresenter(searchInteractor: ImageSearchInteractor())
    
    lazy var tapRecognizer: UITapGestureRecognizer = {
           var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
           return recognizer
       }()
    
//    private var imagesArray: [String] = [] {
//        didSet {
//            toggleError(show: imagesArray.isEmpty ? true : false)
//        }
//    }
    
    private func toggleError(show: Bool) {
        errorView.isHidden = !show
        imagesCollectionView.isHidden = show
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        searchPresenter.presenterDelegate = self
    }
    
    //MARK: Private Functions
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    
    private func showErrorView() {
        
    }

    //MARK: UICollectionView datasource & delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPresenter.numberOfItemsInSection(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchPresenter.numberOfSections(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? ImageCollectionViewCell, let imageModel = searchPresenter.itemForRow(atIndexpath: indexPath) {
            cell.setImage(imagePath: imageModel.previewURL)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        searchPresenter.fetchNextPageIfRequired(indexPath: indexPath)
    }
    
    
    //Mark: Private functions
    private func sizeForItem(collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        let sidePadding : CGFloat = 8.0
        let noOfCells : CGFloat = 2
        let noOfPadding : CGFloat = noOfCells+1
        
        let itemW = (width - (noOfPadding * sidePadding))/noOfCells
        let size = CGSize(width: itemW, height: itemW)
        print("***** size of cell : \(size)")
        return size
    }
}

extension ImageSearchViewController: ImageSearchPresenterDelegate {
    func didFetchPhotos(result: ResultType) {
        switch result {
        case .success(imageModel: _):
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
            }
        case .failure(_):
            self.showErrorView()
        }
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

            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            searchPresenter.getDataWithSearchQuery(searchQuery: searchText)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Add your search logic here
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}
