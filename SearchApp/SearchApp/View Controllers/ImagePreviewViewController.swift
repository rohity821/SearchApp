//
//  ImagePreviewViewController.swift
//  SearchApp
//
//  Created by Rohit.Yadav on 15/05/20.
//  Copyright © 2020 Rohit.Yadav. All rights reserved.
//

import UIKit

protocol ImagePreviewInterfaceProtocol where Self: UIViewController {
    func setImages(images:[ImageDataModel], with currentIndex: Int)
}

class ImagePreviewViewController: UIViewController, ImagePreviewInterfaceProtocol {
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    var currentPageIndex: Int = 0
    
    var images = [ImageDataModel]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = self.view.bounds
    }
    
    func setImages(images:[ImageDataModel], with currentIndex: Int) {
        self.images = images
        currentPageIndex = currentIndex
        let _ = configurePageContentController()
    }
    
    //MARK: Private helper functions
    private func addPageViewController() {
        pageViewController.dataSource = self
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func configurePageContentController() -> PageContentViewInterfaceProtocol{
        let pageController = viewControllerAtIndex(index: currentPageIndex)
        self.pageViewController.setViewControllers([pageController], direction: .forward, animated: false, completion: nil)
        return pageController
    }
    
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
