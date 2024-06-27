//
//  UserDefaultsManager.swift
//  MeaningOut
//
//  Created by 권대윤 on 6/14/24.
//

import UIKit

@propertyWrapper
struct UserDefaultsPropertyWrapper<T> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults
    
    var wrappedValue: T {
        get {
            return self.storage.object(forKey: self.key) as? T ?? self.defaultValue
        }
        set {
            return self.storage.set(newValue, forKey: self.key)
        }
    }
}

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    private var userDefaults = UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard
    
    enum Key: String, CaseIterable {
        case nickname
        case profile
        case recentSearch
        case joinDate
        case like
    }
    
    @UserDefaultsPropertyWrapper(key: Key.nickname.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var nickname: String?
    
    @UserDefaultsPropertyWrapper(key: Key.profile.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var profile: String?
    
    @UserDefaultsPropertyWrapper(key: Key.recentSearch.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var recentSearch: [String]?
    
    @UserDefaultsPropertyWrapper(key: Key.joinDate.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var joinDate: String?
    
    @UserDefaultsPropertyWrapper(key: Key.like.rawValue, defaultValue: nil, storage: UserDefaults(suiteName: "MyUserDefaults") ?? UserDefaults.standard)
    var like: [String: Bool]?
    
    func removeRecentSearchData() {
        userDefaults.removeObject(forKey: Key.recentSearch.rawValue)
    }
    
    func removeUserData(completion: @escaping () -> Void) {
        
        if UserDefaults.standard.persistentDomain(forName: "MyUserDefaults") != nil {
            UserDefaults.standard.removePersistentDomain(forName: "MyUserDefaults")
            
        } else { //UserDefaults(suiteName: "MyUserDefaults")으로 인스턴스 생성 실패에 대비
            if let bundleID = Bundle.main.bundleIdentifier {
                print(bundleID)
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
        }
        
        completion()
    }
}
