//
//  PublicKeyMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol PublicKeyMatcherServiceProtocol {
    
    func publicKey(enviroment: EnviromentService) -> Observable<String>
}
