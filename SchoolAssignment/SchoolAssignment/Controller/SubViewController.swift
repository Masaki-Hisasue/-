//
//  SubViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/09/15.
//

import UIKit
import Foundation
import Alamofire

class SubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var subTableView: UITableView!
    
    let dogApiManager = DogApiManager()
    
    var mainDogData: String?
    
    var subDogData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subTableView.dataSource = self
    }
    
    func tableView(_ subTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(subDogData.count)
        return subDogData.count
    }
    
    func tableView(_ subTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DogBreedDetailViewCell = subTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DogBreedDetailViewCell else {
            let errorCell = UITableViewCell()
            return errorCell
        }
        let breedData = subDogData[indexPath.row]
        cell.subTitle.text = String(describing:breedData)
        return cell
    }
}
