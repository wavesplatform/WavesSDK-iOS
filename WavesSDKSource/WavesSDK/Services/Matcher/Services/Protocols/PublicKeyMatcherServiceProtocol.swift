//
//  PublicKeyMatcherServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol PublicKeyMatcherServiceProtocol {

    /**
      Get matcher public key
     */
    func publicKey() -> Observable<String>
}
