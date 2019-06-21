//
//  AssetsDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AssetsDataServiceProtocol {
    
    func assets(ids: [String]) -> Observable<[DataService.DTO.Asset]>
    
    func asset(id: String) -> Observable<DataService.DTO.Asset>
}
