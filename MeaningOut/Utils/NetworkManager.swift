//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation

enum ShoppingNetwrokError: Error {
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
    
    func fetchShopping(query: String, sort: String, start: Int, completion: @escaping (Result<Shopping, ShoppingNetwrokError>) -> Void) {
        
        let parameters = [
            "query": query,
            "display": String(30),
            "sort": sort,
            "start": String(start),
        ]
        
        let headers = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = APIURL.naverShoppingHost
        component.path = APIURL.naverShoppingPath
        
        //queryString setting
        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
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
        request.httpMethod = HTTPMethodType.GET.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.failedRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Shopping.self, from: data)
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
