//
//  ImagePreviewViewController.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit

protocol ImagePreviewInterfaceProtocol where Self: UIViewController {
    
    /// A function sets the images array to be displayed on screen with currentIndex to display.
    ///
    /// - Parameters:
    ///   - images: an array of ImageDataModel objects which represents all the images being fetched till now.
    ///   - currentIndex: the current index from which we have to display the image.
    func setImages(images:[ImageDataModel], with currentIndex: Int)
}

class ImagePreviewViewController: UIViewController, ImagePreviewInterfaceProtocol {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var currentPageIndex: Int = 0
    
    var images = [ImageDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = self.view.bounds
    }
    
    //MARK: ImagePreviewInterfaceProtocol methods
    func setImages(images:[ImageDataModel], with currentIndex: Int) {
        self.images = images
        currentPageIndex = currentIndex
        configurePageContentController()
    }
    
    //MARK: Private helper functions
    /// This methods adds the pageviewcontroller as a childview controller to the view
    private func addPageViewController() {
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    /// Call this method to set up the first view controller in pagecontroller once the images array is set.
    private func configurePageContentController(){
        let pageController = viewControllerAtIndex(index: currentPageIndex)
        self.pageViewController.setViewControllers([pageController], direction: .forward, animated: false, completion: nil)
    }
    
    /// Call this method to get the viewController for a corresponding index.
    ///
    /// - Parameters:
    /// - index: index for which we need the viewcontroller
    /// - Returns: a object of viewcontroller which conforms to PageContentViewInterfaceProtocol
    private func viewControllerAtIndex(index: Int) -> PageContentViewInterfaceProtocol {
        let pageController = PageContentView(nibName: "PageContentView", bundle: nil)
        pageController.index = index
        let imageModel = images[index]
        pageController.imagePath = imageModel.largeImageURL
        return pageController
    }
    
}

//MARK: UIPageViewControllerDataSource methods
extension ImagePreviewViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? PageContentViewInterfaceProtocol, let index = controller.index, index > 0 else {
            return nil
        }
        let viewController = viewControllerAtIndex(index: index-1)
        return viewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? PageContentViewInterfaceProtocol, let index = controller.index, index < images.count else {
            return nil
        }
        let viewController = viewControllerAtIndex(index: index+1)
        return viewController
    }
}
