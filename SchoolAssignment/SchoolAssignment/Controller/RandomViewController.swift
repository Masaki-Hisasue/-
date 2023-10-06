//
//  RandomViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/09/28.
//

import UIKit

class RandomViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dogApiManager = DogApiManager()
    
    var dogImgUrlList: [String]?
    
    var randomBreed: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        self.navigationItem.title = "ランダム"
        getList()
    }
    
    @objc private func onRefresh(_ sender: AnyObject) {
        getList()
    }
    
    func getList() {
        dogApiManager.rondomDogImage (completion: { dogImgUrlList in
            self.dogImgUrlList = dogImgUrlList
            print(dogImgUrlList)
            self.reloadData()
        })
        DispatchQueue.main.async() {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: RandomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "randomCell", for: indexPath) as? RandomCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        let item = self.dogImgUrlList?[indexPath.row]
        if let smallImageURL = item {
            let url = URL(string: smallImageURL)!
            cell.randomImage.af.setImage(withURL: url)
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
}
