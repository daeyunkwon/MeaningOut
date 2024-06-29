//
//  NAVERAPIEndpoint.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/29/24.
//

import Foundation

enum NAVERAPI {
    case shopping(query: String, sort: String, start: Int)
    
    enum Method: String {
        case get = "GET"
    }
    
    var schmem: String {
        return "https"
    }
    
    var host: String {
        switch self {
        case .shopping:
            return APIURL.naverShoppingHost
        }
    }
    
    var path: String {
        switch self {
        case .shopping:
            return APIURL.naverShoppingPath
        }
    }
    
    var header: [String: String] {
        return ["X-Naver-Client-Id": APIKey.clientId,
                "X-Naver-Client-Secret": APIKey.clientSecret]
    }
    
    var parameter: [String: String] {
        switch self {
        case .shopping(let query, let sort, let start):
            return [
                "query": query,
                "display": String(30),
                "sort": sort,
                "start": String(start),
            ]
        }
    }
}
