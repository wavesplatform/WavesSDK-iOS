//
//  AssetsNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AssetsNodeServiceProtocol {
    
    func assetsBalances(address: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountAssetsBalance>
    
    func assetBalance(address: String, assetId: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AccountAssetBalance>
    
    func assetDetails(assetId: String, enviroment: EnviromentService) -> Observable<NodeService.DTO.AssetDetail>
}
