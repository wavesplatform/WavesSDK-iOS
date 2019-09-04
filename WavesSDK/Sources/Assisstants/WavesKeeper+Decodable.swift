//
//  WavesKeeper+Decodable.swift
//  WavesSDK
//
//  Created by Pavel Gubin on 04.09.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation

//MARK: - Error
extension WavesKeeper.Error {
    
    private enum CodingKeys: String, CodingKey {
        case reject
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let _ = try? values.decode(String.self, forKey: .reject) {
            self = .reject
            return
        }
        
        if let value = try? values.decode(Message.self, forKey: .message) {
            self = .message(value)
            return
        }
        
        throw NSError(domain: "Decoder Invalid", code: 0, userInfo: nil)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .reject:
            try container.encode(CodingKeys.reject.rawValue, forKey: .reject)
            
        case .message(let value):
            try container.encode(value, forKey: .message)
        }
    }
}


extension WavesKeeper.Success {
    
    enum CodingKeys: String, CodingKey {
        case sign
        case send
    }
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(NodeService.Query.Transaction.self, forKey: .sign) {
            self = .sign(value)
            return
        }
        
        if let value = try? values.decode(NodeService.DTO.Transaction.self, forKey: .send) {
            self = .send(value)
            return
        }
        
        throw NSError(domain: "Decoder Invalid", code: 0, userInfo: nil)
    }
    
    public func encode(to encoder: Encoder) throws {
       
        do {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .sign(let value):
                try container.encode(value, forKey: .sign)
                
            case .send(let value):
                try container.encode(value, forKey: .send)
            }
        } catch let e {
            throw NSError(domain: "Encoder Invalid WavesKeeper.Success", code: 0, userInfo: nil)
        }

    }
}