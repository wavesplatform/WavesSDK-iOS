//
//  Encodable+Base64.swift
//  WavesSDK
//
//  Created by rprokofev on 04.09.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation


public extension Encodable {
    
    var encodableToBase64: String? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return data.base64EncodedString()
    }
}

public extension String {
    
    func decodableBase64ToObject<T: Decodable>() -> T? {
        
        guard let newData = Data(base64Encoded: self) else { return nil }
        
        
        do {
            let object = try JSONDecoder().decode(T.self, from: newData) 
            return object
        } catch let error {
            print("error \(error)")
        }
        
        return nil
    }
}
