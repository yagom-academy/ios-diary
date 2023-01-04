//
//  NetworkManager.swift
//  Diary
//  Created by inho, dragon on 2023/01/04.
//

import Foundation

struct NetworkManager {
    func performRequest(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            print(data)
        }
        
        task.resume()
    }
}
