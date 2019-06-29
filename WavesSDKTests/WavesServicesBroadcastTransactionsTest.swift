//
//  WavesServicesBroadcastTransactions.swift
//  WavesSDKTests
//
//  Created by rprokofev on 28.06.2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxTest
import WavesSDK
import WavesSDKExtensions
import Nimble

class WavesServicesBroadcastTransactionsTest: WavesServicesTest {
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private var scheduler: TestScheduler = TestScheduler(initialClock: 10000)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {}
    
    func testTransferTx() {
        
        let expectation = XCTestExpectation(description: "response")
        
        let recipient = address!
        let fee: Int64 = 100000
        let amount: Int64 = 100000
        let feeAssetId = ""
        let assetId = ""
        let attachment = ""
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000

        var queryModel = NodeService.Query.Broadcast.Transfer(recipient: recipient,
                                                              assetId: assetId,
                                                              amount: amount,
                                                              fee: fee,
                                                              attachment: attachment,
                                                              feeAssetId: feeAssetId,
                                                              timestamp: timestamp,
                                                              senderPublicKey: senderPublicKey)
        queryModel.sign(seed: seed, chainId: chainId)

        let send = NodeService.Query.Broadcast.transfer(queryModel)

        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (tx) in
                print("tx \(tx)")
                XCTAssertTrue(true)
                expectation.fulfill()
            }, onError: { (error) in
                print("error \(error)")
                XCTFail()
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 20)
    }
    
    func testDataTx() {
        
        let expectation = XCTestExpectation(description: "response")
        
        let recipient = address!
        let fee: Int64 = 100000
        let amount: Int64 = 100000
        let feeAssetId = ""
        let assetId = ""
        let attachment = ""
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        
        
        let data = NodeService.Query.Broadcast.Data.Value.init(key: "size_zalypa", value: .integer(10))

        var queryModel = NodeService.Query.Broadcast.Data.init(fee: fee,
                                                               timestamp: timestamp,
                                                               senderPublicKey: senderPublicKey,
                                                               data: [data])
        
        let send = NodeService.Query.Broadcast.data(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .broadcast(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (tx) in
                XCTAssertTrue(true, "\(tx)")
            }, onError: { (error) in
                XCTAssertTrue(false, error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
//        wait(for: [expectation], timeout: 60)
    }
}
