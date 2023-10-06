//
//  PageViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/10/02.


import UIKit
import Foundation
import Alamofire
import AlamofireImage

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let dogApiManager = DogApiManager()
    
    var pagingDogImageList: [String]?
    
    var firstIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setUpPagingView()
    }
    
    private func setUpPagingView() {
        guard let imageViewController = self.initPageViewController(index: firstIndex) else {
            return
        }
        self.setViewControllers([imageViewController], direction: .forward, animated: true)
    }
    
    private func initPageViewController(index: Int) -> SingleViewController? {
        guard let singleViewController = storyboard?.instantiateViewController(identifier: "DogPageView") as? SingleViewController else { return nil }
        // url set
        singleViewController.loadViewIfNeeded()
        if let imageURL = pagingDogImageList?[index] {
            guard let url = URL(string: imageURL) else { return nil }
            singleViewController.dogPageImage.af.setImage(withURL: url)
        }
        singleViewController.index = index
        singleViewController.scrollView.minimumZoomScale = 1.0
        singleViewController.scrollView.maximumZoomScale = 3.0
        return singleViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = pageViewController.viewControllers?.first as? SingleViewController else {
            // 表示中のViewがない=不正に呼ばれたケース
            return nil
        }
        let index = vc.index
        let prevPageIndex = index - 1
        if prevPageIndex < 0 {
            return nil
        }
        guard let imageViewController = self.initPageViewController(index: prevPageIndex) else {
            return nil
        }
        return imageViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let contentVC = pageViewController.viewControllers?.first as? SingleViewController  else { return nil }
        let index = contentVC.index
        let afterPageIndex = index + 1
        if let dogList = self.pagingDogImageList,
           dogList.count - 1 < afterPageIndex {
            return nil
        }
        guard let imageViewController = self.initPageViewController(index: afterPageIndex) else {
            return nil
        }
        return imageViewController
    }
}
