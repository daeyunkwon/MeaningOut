//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/20/24.
//

import UIKit

enum NaverNetwrokError: Error {
    case failedCreateURL
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case failedDecode
    
    var errorDescription: String {
        switch self {
        case .failedCreateURL:
            return "Error: URL이 유효하지 않아 생성 실패"
        case .failedRequest:
            return "Error: Request가 유효하지 않아 생성 실패"
        case .noData:
            return "Error: 데이터가 없습니다"
        case .invalidResponse:
            return "Error: Response가 유효하지 않습니다"
        case .invalidData:
            return "Error: 데이터가 유효하지 않습니다"
        case .failedDecode:
            return "Error: Decoding 실패"
        }
    }
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    var session: URLSession!
    
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
    
    func fetchDataUsingURLSessionDelegate(api: NAVERAPI, delegate: UIViewController) {
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
            print(NaverNetwrokError.failedCreateURL.errorDescription)
            return
        }
        var request = URLRequest(url: url, timeoutInterval: 10)
        
        //header setting
        request.httpMethod = NAVERAPI.Method.get.rawValue
        for (key, value) in api.header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        session = URLSession(configuration: .default, delegate: delegate as? URLSessionDelegate, delegateQueue: .main)
        session.dataTask(with: request).resume()
    }
}
