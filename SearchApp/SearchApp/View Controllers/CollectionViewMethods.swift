//
//  CollectionViewMethods.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 16/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import Foundation
import UIKit

// class for data source of Collection view
class SearchCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    var searchPresenter: ImageSearchPresenterInterfaceProtocol
    
    init(presenter: ImageSearchPresenterInterfaceProtocol) {
        searchPresenter = presenter
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchPresenter.numberOfItemsInSection(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchPresenter.numberOfSections(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell, let imageModel = searchPresenter.itemForRow(atIndexpath: indexPath) {
            imageCell.setImage(imagePath: imageModel.previewURL)
        }
            return cell
    }
}

// Class for delegate of collectionview
class SearchCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var searchPresenter: ImageSearchPresenterInterfaceProtocol
    weak var viewController: UIViewController?
    
    init(presenter: ImageSearchPresenterInterfaceProtocol, viewController: UIViewController) {
        searchPresenter = presenter
        self.viewController = viewController
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        searchPresenter.fetchNextPageIfRequired(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = viewController {
            searchPresenter.didSelectRow(atIndexpath: indexPath, viewController: vc)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}
