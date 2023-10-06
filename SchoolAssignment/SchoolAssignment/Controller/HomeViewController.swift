//
//  HomeViewController.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/09/12.
//

import UIKit
import Foundation
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dogApiManager = DogApiManager()
    
    var dogList: [BreedsData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ホーム"
        tableView.dataSource = self
        getList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func getList() {
        self.dogApiManager.getBreedsList(completion: { [self] dogClosure in
            getDogListData(dogData: dogClosure)
            print(dogClosure)
            reloadData()
        })
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getDogListData(dogData: [String: [String]]) {
        var dogsList: [BreedsData] = []
        for dogs in dogData {
            let breedsData = BreedsData(breed: dogs.key, subBreeds: dogs.value)
            dogsList.append(breedsData)
        }
        dogsList.sort(by: {$0.breed < $1.breed})
        self.dogList = dogsList
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "GoNext", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DogBreedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DogBreedTableViewCell else {
            let errorCell = UITableViewCell()
            return errorCell
        }
        let breedData = dogList[indexPath.row]
        cell.homeTitle.text = breedData.breed
        if breedData.subBreeds.count == 0 {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .detailDisclosureButton
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoNext" {
            if let subViewController: SubViewController = segue.destination as? SubViewController {
                if let indexPath = sender as? IndexPath {
                    subViewController.mainDogData = dogList[indexPath.row].breed
                    subViewController.subDogData = dogList[indexPath.row].subBreeds
                }
            }
        } else if segue.identifier == "GoTile" {
            if let tileViewController: TileViewController = segue.destination as?  TileViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    tileViewController.tileViewTitle = dogList[indexPath.row].breed
                    tileViewController.subTileViewTitle = dogList[indexPath.row].subBreeds
                }
            }
        } else if segue.identifier == "GoRandom" {
            if let randomViewController: RandomViewController = segue.destination as?  RandomViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    randomViewController.randomBreed = dogList[indexPath.row].breed
                }
            }
        }
    }
}
