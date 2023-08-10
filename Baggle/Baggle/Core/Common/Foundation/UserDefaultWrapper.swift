//
//  UserDefaultWrapper.swift
//  Baggle
//
//  Created by 양수빈 on 2023/07/25.
//

import Foundation

@propertyWrapper struct UserDefaultWrapper<T: Codable> {
    
    private let key: UserDefaultKey
    private let defaultValue: T?
    
    init(key: UserDefaultKey, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key.rawValue) as? Data {
                let decoder = JSONDecoder()
                if let loadedObject = try? decoder.decode(T.self, from: savedData) {
                    return loadedObject
                }
            }
            return defaultValue
        }
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            } else {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newValue) {
                    UserDefaults.standard.setValue(encoded, forKey: key.rawValue)
                }
            }
        }
    }
}
