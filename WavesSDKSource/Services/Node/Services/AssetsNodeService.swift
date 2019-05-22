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
    
    init(assetsProvider: MoyaProvider<NodeService.Target.Assets>) {
        self.assetsProvider = assetsProvider
    }
    
    public func assetsBalances(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountAssetsBalance> {
      
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalances(walletAddress: address),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .asObservable()
            .catchError({ (error) -> Observable<Response> in
                return Observable.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AccountAssetsBalance.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
    
    public func assetBalance(address: String, assetId: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountAssetBalance> {
        
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .getAssetsBalance(address: address, assetId: assetId),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AccountAssetBalance.self)
            .asObservable()
    }
    
    public func assetDetails(assetId: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AssetDetail> {
        return self
            .assetsProvider
            .rx
            .request(.init(kind: .details(assetId: assetId),
                           nodeUrl: enviroment.serverUrl),
                     callbackQueue: DispatchQueue.global(qos: .userInteractive))
            .filterSuccessfulStatusAndRedirectCodes()
            .catchError({ (error) -> Single<Response> in
                return Single.error(NetworkError.error(by: error))
            })
            .map(NodeService.DTO.AssetDetail.self)
            .asObservable()
    }
}
