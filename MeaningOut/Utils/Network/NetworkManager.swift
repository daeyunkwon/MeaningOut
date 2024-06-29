//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation

enum NaverNetwrokError: Error {
    case failedCreateURL
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case failedDecode
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    private enum HTTPMethodType: String {
        case GET
    }
    
    func fetchData<T: Decodable>(api: NAVERAPI, model: T.Type , completion: @escaping (Result<T, NaverNetwrokError>) -> Void) {
        
        var component = URLComponents()
        component.scheme = api.schmem
        component.host = api.host
        component.path = api.path
        
        //queryString setting
        var queryItems = [URLQueryItem]()
        for (key, value) in api.parameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        component.queryItems = queryItems
        
        //create URLRequest
        guard let url = component.url else {
            completion(.failure(.failedCreateURL))
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        
        //header setting
        request.httpMethod = NAVERAPI.Method.get.rawValue
        for (key, value) in api.header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        //task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.failedRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard response.statusCode == 200 else {
                print("Failed Response: \(response.statusCode)")
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.failedDecode))
                }
            }
        }
        
        task.resume()
    }
    
}
