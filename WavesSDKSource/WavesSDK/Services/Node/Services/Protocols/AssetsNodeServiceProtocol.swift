//
//  AssetsNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AssetsNodeServiceProtocol {
    
    func assetsBalances(address: String) -> Observable<NodeService.DTO.AddressAssetsBalance>
    
    func assetBalance(address: String, assetId: String) -> Observable<NodeService.DTO.AddressAssetBalance>
    
    func assetDetails(assetId: String) -> Observable<NodeService.DTO.AssetDetail>
}
