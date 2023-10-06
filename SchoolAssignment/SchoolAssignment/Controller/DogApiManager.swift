//
//  HomeViewManager.swift
//  SchoolAssignment
//
//  Created by school09 on 2023/09/12.
//

import Foundation
import Alamofire

enum InternalError: Error {
    case encodeError
    case decodeError
}

class DogApiManager {
    func getBreedsList(completion: @escaping ( [String: [String]]) -> Void) {
        do {
            guard let url = URL(string: "https://dog.ceo/api/breeds/list/all?api_key=live_RePLN7QsXlaRdVlljl33CeLsR0eweEIzRcZiv6rW8zn2ku8Ddknd1qZKnK4asy6H") else {
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let breedsListData = data else {
                    return
                }
                do {
                    guard let object = try JSONSerialization.jsonObject(with: breedsListData) as? [String: Any] else { return }
                    guard let dogMessage = object["message"] as? [String: [String]] else { return }
                    completion(dogMessage)
                    print(dogMessage)
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    func getDogImage(urlPath: String, completion: @escaping ([String]) -> Void) {
        do {
            let baseUrlString = "https://dog.ceo/api/breed/DOGBREED/images"
            let replaceStr = baseUrlString.replacingOccurrences(of: "DOGBREED", with: urlPath)
            guard let url = URL(string: replaceStr) else {
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let dogImageData = data else {
                    return
                }
                do {
                    guard let object = try JSONSerialization.jsonObject(with: dogImageData) as? [String: Any] else { return }
                    guard let dogImageMessage = object["message"] as? [String] else { return }
                    completion(dogImageMessage)
                    print(dogImageMessage)
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
    
    func rondomDogImage(completion: @escaping ([String]) -> Void) {
        do {
            guard let url = URL(string: "https://dog.ceo/api/breeds/image/random/50") else {
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                guard let rondomImageData = data else {
                    return
                }
                do {
                    guard let object = try JSONSerialization.jsonObject(with: rondomImageData) as? [String: Any] else { return }
                    guard let rondomImageMessage = object["message"] as? [String] else { return }
                    completion(rondomImageMessage)
                    print(rondomImageMessage)
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
