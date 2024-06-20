//
//  NetworkManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/20/24.
//

import Foundation

import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchShopping(query: String, sort: String, start: Int, completion: @escaping (Shopping) -> Void) {
        let param: Parameters = [
            "query": query,
            "display": 30,
            "sort": sort,
            "start": start
        ]
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientId,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(APIURL.naverShoppingURL, parameters: param, encoding: URLEncoding.queryString, headers: header).responseDecodable(of: Shopping.self) { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
    
    
}
