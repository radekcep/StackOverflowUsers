//
//  KeyValueStorageMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

@testable import StackOverflowUsers

class KeyValueStorageMock: KeyValueStorageProtocol {
    var setValue: (Bool, String) -> Void
    var value: (String) -> Bool?
    
    init(setValue: @escaping (Bool, String) -> Void, value: @escaping (String) -> Bool?) {
        self.setValue = setValue
        self.value = value
    }
    
    func set(value: Bool, forKey key: String) {
        setValue(value, key)
    }
    
    func value(forKey key: String) -> Bool? {
        value(key)
    }
}
