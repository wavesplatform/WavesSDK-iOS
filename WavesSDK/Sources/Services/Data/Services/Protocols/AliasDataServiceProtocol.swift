 //
//  AliasDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AliasDataServiceProtocol {
    
    func alias(name: String) -> Observable<DataService.DTO.Alias>
    
    func aliases(address: String) -> Observable<[DataService.DTO.Alias]>
}
