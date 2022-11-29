//
//  InternalWavesService.swift
//  Alamofire
//
//  Created by rprokofev on 03/06/2019.
//

import Foundation

internal class InternalWavesService: InternalWavesServiceProtocol {
    
    private var internalEenviroment: WavesEnvironment
    
    internal(set) public var enviroment: WavesEnvironment {
        
        get {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            return internalEenviroment
        }
        
        set {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            internalEenviroment = newValue
        }
    }
    
    init(enviroment: WavesEnvironment) {
        self.internalEenviroment = enviroment
    }
}
