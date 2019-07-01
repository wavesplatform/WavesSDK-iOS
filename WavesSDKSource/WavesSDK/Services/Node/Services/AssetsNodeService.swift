//
//  AssetsNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

final class AssetsNodeService: AssetsNodeServiceProtocol {
    
    private let assetsProvider: MoyaProvider<NodeService.Target.Assets>
    var enviroment: Enviroment
    
    init(assetsProvider: MoyaProvider<NodeService.Target.Assets>, enviroment: Enviroment) {
        self.assetsProvider = assetsProvider
        self.enviroment = enviroment
    }

    /**
      Account's balances for all assets by address
      - Parameter: address Address
      */
    public func assetsBalances(address: String) -> Observable<NodeService.DTO.AddressAssetsBalance> {
      
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalances(walletAddress: address),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .catchError({ (error) -> Observable<Response> in
                return Observable.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressAssetsBalance.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .catchError({ (error) -> Observable<NodeService.DTO.AddressAssetsBalance> in
                return Observable.error(NetworkError.error(by: error))
            })
            .asObservable()
    }

    /**
      Account's assetId balance by address
      - Parameter: address Address
      - Parameter: assetId AssetId
      */
    public func assetBalance(address: String, assetId: String) -> Observable<NodeService.DTO.AddressAssetBalance> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalance(address: address, assetId: assetId),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AddressAssetBalance.self)
            .asObservable()
    }

    /**
      Provides detailed information about given asset
      - Parameter: assetId Asset Id
      */
    public func assetDetails(assetId: String) -> Observable<NodeService.DTO.AssetDetail> {
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .details(assetId: assetId),
                           nodeUrl: enviroment.nodeUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AssetDetail.self)
            .asObservable()
    }
}
