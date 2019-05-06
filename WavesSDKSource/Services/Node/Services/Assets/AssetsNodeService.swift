//
//  AssetsNodeTarget.swift
//  Alamofire
//
//  Created by rprokofev on 30/04/2019.
//

import Foundation
import RxSwift
import Moya

public protocol AssetsNodeServiceProtocol {
    
    func assetsBalances(address: String, enviroment: EnviromentService) -> Observable<Node.DTO.AccountAssetsBalance>
    
    func assetBalance(address: String, assetId: String, enviroment: EnviromentService) -> Observable<Node.DTO.AccountAssetBalance>
    
    func assetDetails(assetId: String, enviroment: EnviromentService) -> Observable<Node.DTO.AssetDetail>
}

public final class AssetsNodeService: AssetsNodeServiceProtocol {
    
    private let assetsProvider: MoyaProvider<Node.Service.Assets> = .nodeMoyaProvider()
    
    public func assetsBalances(address: String, enviroment: EnviromentService) -> Observable<Node.DTO.AccountAssetsBalance> {
      
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
            .map(Node.DTO.AccountAssetsBalance.self, atKeyPath: nil, using: JSONDecoder.decoderBySyncingTimestamp(enviroment.timestampServerDiff), failsOnEmptyData: false)
            .asObservable()
    }
    
    public func assetBalance(address: String, assetId: String, enviroment: EnviromentService) -> Observable<Node.DTO.AccountAssetBalance> {
        
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
            .map(Node.DTO.AccountAssetBalance.self)
            .asObservable()
    }
    
    public func assetDetails(assetId: String, enviroment: EnviromentService) -> Observable<Node.DTO.AssetDetail> {
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
            .map(Node.DTO.AssetDetail.self)
            .asObservable()
    }
}
