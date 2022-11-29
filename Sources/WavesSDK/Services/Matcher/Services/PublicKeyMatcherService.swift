//
//  PublicKeyMatcherService.swift
//  Alamofire
//
//  Created by rprokofev on 06/05/2019.
//

import Foundation
import RxSwift
import Moya
import RxMoya

final class PublicKeyMatcherService: InternalWavesService, PublicKeyMatcherServiceProtocol {
    
    private let publicKeyProvider: MoyaProvider<MatcherService.Target.MatcherPublicKey>
    
    init(publicKeyProvider: MoyaProvider<MatcherService.Target.MatcherPublicKey>, enviroment: WavesEnvironment) {
        self.publicKeyProvider = publicKeyProvider
        super.init(enviroment: enviroment)
    }
    
    public func publicKey() -> Observable<String> {
        
        return self
            .publicKeyProvider
            .rx
            .request(.init(matcherUrl: enviroment.matcherUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single<Response>.error(NetworkError.error(by: error))
            })
            .flatMap({ (response) -> Single<String> in
                
                do {
                    guard let key = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? String else {
                        return Single.error(NetworkError.none)
                    }
                    return Single.just(key)
                } catch let error {
                    return Single.error(error)
                }
            })
            .asObservable()
    }
}
