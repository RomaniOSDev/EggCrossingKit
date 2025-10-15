//
//  CheckLink.swift
//  RescueRooster
//
//  Created by Damon Earley on 02.09.2025.
//

import Foundation


struct CheckURLService {
    
    static let link = URL(string: "https://eggskipper.space/qy8g8vDH")
    
    static  func checkURLStatus( completion: @escaping (Bool) -> Void) {
        guard let url = link  else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { _, response, error in
            if let error = error {
                print("Error http: \(error.localizedDescription)")
        
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 404 {
                    print("http response code is \(httpResponse.statusCode)")
                    completion(true)
                    
                } else {
                    print("code is 404")
                    completion(false)
                }
            } else {
                print("http response bad")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    
}
