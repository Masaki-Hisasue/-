//
//  DogPageViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/10/02.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class SingleViewController: UIViewController {
    
    @IBOutlet weak var dogPageImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doubleTapGesture = UITapGestureRecognizer(target: self, action:#selector(self.doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        scrollView.delegate = self
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //                self.view.layoutIfNeeded()
    //        adjustImageView()
    //        updateContentInset()
    //}
    
    /// ImageViewのサイズがScrollViewの表示範囲より小さい場合に、画面中央に配置されるようにcontentInsetを設定する
    private func updateContentInset() {
        guard let singleViewController = storyboard?.instantiateViewController(identifier: "DogPageView") as?  SingleViewController else { return }
        singleViewController.loadViewIfNeeded()
        singleViewController.scrollView.contentInset = UIEdgeInsets(
            top: max((singleViewController.scrollView.frame.height - singleViewController.dogPageImage.frame.height) / 2, 0),
            left: max((singleViewController.scrollView.frame.width - singleViewController.dogPageImage.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
    
    /// ImageViewをScrollViewの表示範囲に収まるように調整する
    private func adjustImageView() {
        guard let singleViewController = storyboard?.instantiateViewController(identifier: "DogPageView") as?  SingleViewController else { return }
        singleViewController.loadViewIfNeeded()
        guard let image = singleViewController.dogPageImage.image else {
            return
        }
        let widthRate = singleViewController.scrollView.bounds.width / image.size.width
        let heightRate = singleViewController.scrollView.bounds.height / image.size.height
        let rate = min(widthRate, heightRate, 1)
        singleViewController.dogPageImage.frame.size = CGSize(width: image.size.width * rate, height: image.size.height * rate)
        singleViewController.scrollView.contentSize = singleViewController.dogPageImage.frame.size
    }
    
    @objc func doubleTap(gesture: UITapGestureRecognizer) -> Void {
        //print(self.myScrollView.zoomScale)
        if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
            let newScale = self.scrollView.zoomScale * 3
            let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view))
            self.scrollView.zoom(to: zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(1.0, animated: true)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    func zoomRectForScale(scale:CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(
            width: self.scrollView.frame.size.width / scale,
            height: self.scrollView.frame.size.height / scale
            
        )
        return CGRect(
            origin: CGPoint(
                x: center.x - size.width / 2.0,
                y: center.y - size.height / 2.0
            ),
            size: size
        )
    }
}

extension SingleViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        dogPageImage
    }
    // ズームイベント
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
