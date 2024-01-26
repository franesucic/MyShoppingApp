//
//  IdGenerator.swift
//  MyShoppingApp
//
//  Created by Frane Sučić on 21.01.2024..
//

import Foundation

class IdGenerator {
    
    private static let counterKey = "idCounter"
    
    static func generateProductid() -> Int32 {
        var counter = UserDefaults.standard.integer(forKey: counterKey)
        counter += 1
        UserDefaults.standard.set(counter, forKey: counterKey)
        UserDefaults.standard.synchronize()
        return Int32(counter)
    }
    
}
