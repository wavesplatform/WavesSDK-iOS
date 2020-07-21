//
//  AssetsDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AssetsDataServiceProtocol {

    /**
      Get a list of assets info from a list of IDs
     */
    func assets(ids: [String]) -> Observable<[DataService.DTO.Asset?]>

    /**
      Get asset info by asset ID
      */
    func asset(id: String) -> Observable<DataService.DTO.Asset>
    
    func searchAssets(search: String, limit: Int) -> Observable<[DataService.DTO.Asset]>
}
