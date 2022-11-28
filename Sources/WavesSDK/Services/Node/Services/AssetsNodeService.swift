//
//  AssetsNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class AssetsNodeService: InternalWavesService, AssetsNodeServiceProtocol {
    
    private let assetsProvider: MoyaProvider<NodeService.Target.Assets>
    
    init(assetsProvider: MoyaProvider<NodeService.Target.Assets>, enviroment: WavesEnvironment) {
        self.assetsProvider = assetsProvider
        super.init(enviroment: enviroment)
    }

    public func assetsBalances(address: String) -> Observable<NodeService.DTO.AddressAssetsBalance> {
      
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalances(walletAddress: address),
                           nodeUrl: enviroment.nodeUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .catch({ (error) -> Observable<Response> in
                return Observable.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressAssetsBalance.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .catch({ (error) -> Observable<NodeService.DTO.AddressAssetsBalance> in
                return Observable.error(NetworkError.error(by: error))
            })
            .asObservable()
    }

    public func assetBalance(address: String, assetId: String) -> Observable<NodeService.DTO.AddressAssetBalance> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalance(address: address, assetId: assetId),
                           nodeUrl: enviroment.nodeUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressAssetBalance.self)
            .asObservable()
    }

    public func assetDetails(assetId: String) -> Observable<NodeService.DTO.AssetDetail> {
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .details(assetId: assetId),
                           nodeUrl: enviroment.nodeUrl))
            .filterSuccessfulStatusAndRedirectCodes()
            .catch({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AssetDetail.self)
            .asObservable()
    }
}
