//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    enum Key: String {
        case nickname
        case profile
        case recentSearch
        case joinDate
        case like
    }
    
    var nickname: String? {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var profile: String? {
        get {
            return userDefaults.string(forKey: Key.profile.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.profile.rawValue)
        }
    }
    
    var recentSearch: [String]? {
        get {
            return userDefaults.stringArray(forKey: Key.recentSearch.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.recentSearch.rawValue)
        }
    }
    
    var joinDate: String? {
        get {
            return userDefaults.string(forKey: Key.joinDate.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.joinDate.rawValue)
        }
    }
    
    var like: Int {
        get {
            return userDefaults.integer(forKey: Key.like.rawValue)
        }
        set {
            userDefaults.setValue(newValue, forKey: Key.like.rawValue)
        }
    }
}
