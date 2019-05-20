//
//  PublicKeyMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya

public protocol PublicKeyMatcherServiceProtocol {
    
    func publicKey(enviroment: EnviromentService) -> Observable<String>
}

final class PublicKeyMatcherService: PublicKeyMatcherServiceProtocol {
    
    private let publicKeyProvider: MoyaProvider<MatcherService.Target.MatcherPublicKey>
    
    init(publicKeyProvider: MoyaProvider<MatcherService.Target.MatcherPublicKey>) {
        self.publicKeyProvider = publicKeyProvider
    }
    
    public func publicKey(enviroment: EnviromentService) -> Observable<String> {
        
        return self
            .publicKeyProvider
            .rx
            .request(.init(matcherUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(String.self)
            .asObservable()
    }
}


