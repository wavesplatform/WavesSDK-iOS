 //
//  AliasDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AliasDataServiceProtocol {

    /**
      Get address for alias
     */
    func alias(name: String) -> Observable<DataService.DTO.Alias>

    /**
      Get a list of aliases for a given address
     */
    func aliases(address: String) -> Observable<[DataService.DTO.Alias]>
}
