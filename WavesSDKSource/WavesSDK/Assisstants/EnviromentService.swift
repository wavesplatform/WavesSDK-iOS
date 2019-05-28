//
//  EnviromentService.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation

public struct EnviromentService {
    public var serverUrl: URL
    public var timestampServerDiff: Int64
    
    public init(serverUrl: URL) {
        self.init(serverUrl: serverUrl, timestampServerDiff: 0)
    }
    
    public init(serverUrl: URL, timestampServerDiff: Int64) {
        self.serverUrl = serverUrl
        self.timestampServerDiff = timestampServerDiff
    }
}
