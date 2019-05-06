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

public final class PublicKeyMatcherService: PublicKeyMatcherServiceProtocol {
    
    private let matcherProvider: MoyaProvider<Matcher.Service.MatcherPublicKey> = .nodeMoyaProvider()
    
    public func publicKey(enviroment: EnviromentService) -> Observable<String> {
        
        return self
            .matcherProvider
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


