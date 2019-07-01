//
//  AssetsNodeServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AssetsNodeServiceProtocol {

    /**
      Account's balances for all assets by address
      - Parameter: address Address
     */

    func assetsBalances(address: String) -> Observable<NodeService.DTO.AddressAssetsBalance>

    /**
      Account's assetId balance by address
      - Parameter: address Address
      - Parameter: assetId AssetId
     */
    func assetBalance(address: String, assetId: String) -> Observable<NodeService.DTO.AddressAssetBalance>

    /**
      Provides detailed information about given asset
      - Parameter: assetId Asset Id
     */
    func assetDetails(assetId: String) -> Observable<NodeService.DTO.AssetDetail>
}
