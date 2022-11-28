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

final class LeasingNodeService: InternalWavesService, LeasingNodeServiceProtocol {
    
    private let leasingProvider: MoyaProvider<NodeService.Target.Leasing>
    
    init(leasingProvider: MoyaProvider<NodeService.Target.Leasing>, enviroment: WavesEnvironment) {
        self.leasingProvider = leasingProvider
        super.init(enviroment: enviroment)
    }

    public func leasingActiveTransactions(by address: String) -> Observable<[NodeService.DTO.LeaseResponse]> {
        
        return self
            .leasingProvider
            .rx
            .request(.init(kind: .getActive(address: address),
                           nodeUrl: enviroment.nodeUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map([NodeService.DTO.LeaseResponse].self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
}
