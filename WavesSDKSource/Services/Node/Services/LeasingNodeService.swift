//
//  LeasingNodeService.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 18.07.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol LeasingNodeServiceProtocol {
    
    func activeLeasingTransactions(by address: String, enviroment: EnviromentService) -> Observable<[Node.DTO.LeaseTransaction]>
}

final class LeasingNodeService: LeasingNodeServiceProtocol {
    
    private let leasingProvider: MoyaProvider<Node.Service.Leasing>
    
    init(leasingProvider: MoyaProvider<Node.Service.Leasing>) {
        self.leasingProvider = leasingProvider
    }
    
    public func activeLeasingTransactions(by address: String, enviroment: EnviromentService) -> Observable<[Node.DTO.LeaseTransaction]> {
        
        return self
            .leasingProvider
            .rx
            .request(.init(kind: .getActive(accountAddress: address),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([Node.DTO.LeaseTransaction].self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
}
