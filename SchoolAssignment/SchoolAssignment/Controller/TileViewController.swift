//
//  TileViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/09/22.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage


class TileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let dogApiManager = DogApiManager()

    var dogImgUrlList: [String]?
    
    var tileViewTitle: String?
    
    var subTileViewTitle: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        guard let displayTitle = tileViewTitle else { return }
        self.navigationItem.title = displayTitle
        getList()
    }
    
    func getList() {
        guard let urlPath = tileViewTitle else { return }
        dogApiManager.getDogImage (urlPath: urlPath, completion: { dogImgUrlList in
            self.dogImgUrlList = dogImgUrlList
            print(dogImgUrlList)
            self.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dogImgUrlList = dogImgUrlList else { return 0 }
        return dogImgUrlList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: DogCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tileCell", for: indexPath) as? DogCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        let item = self.dogImgUrlList?[indexPath.row]
        
        if let smallImageURL = item {
            let url = URL(string: smallImageURL)!
            cell.dogImages.af.setImage(withURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 0
        let cellSize : CGFloat = self.view.bounds.width / 2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoPaging" {
            if let pageViewController: PageViewController = segue.destination as? PageViewController {
                if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                    pageViewController.firstIndex = indexPath.row
                    pageViewController.pagingDogImageList = self.dogImgUrlList
                }
            }
        }
    }
}
