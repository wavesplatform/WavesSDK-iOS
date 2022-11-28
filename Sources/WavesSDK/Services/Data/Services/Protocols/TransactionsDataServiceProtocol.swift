//
//  TransactionsDataServiceProtocol.swift
//  Alamofire
//
//  Created by rprokofev on 22/05/2019.
//

import Foundation
import RxSwift

public protocol TransactionsDataServiceProtocol {

  /**
   Get a list of exchange transactions by applying filters
   */
  func transactionsExchange(txId: String) -> Observable<DataService.DTO.ExchangeTransaction>

  func transactionsExchange(query: DataService.Query.ExchangeFilters) -> Observable<[DataService.DTO.ExchangeTransaction]>

  func getMassTransfer(txId: String)
  -> Observable<DataService.DTO.MassTransferTransaction>

  func getMassTransferTransactions(query: DataService.Query.MassTransferDataQuery)
  -> Observable<DataService.Response<[DataService.DTO.MassTransferTransaction]>>

  // TODO: All, Genesis, Payment, Issue, Transfer, ReIssue, Burn, Lease, LeaseCancel, Alias, Data, Sponsorship, SetScript, SetAssetScript, InvokeScript
}
