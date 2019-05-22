//
//  AliasDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol AliasDataServiceProtocol {
    
    func alias(name: String, enviroment: EnviromentService) -> Observable<DataService.DTO.Alias>
    
    func list(address: String, enviroment: EnviromentService) -> Observable<[DataService.DTO.Alias]>
}
