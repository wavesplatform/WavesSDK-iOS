//
//  ViewController.swift
//  WavesSDK
//
//  Created by rprokofev on 03/04/2019.
//  Copyright © 2019 Waves. All rights reserved.
//

import UIKit
import WavesSDK
import WavesSDKCrypto
import RxSwift

final class AssetCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!    
    @IBOutlet var balanceLabel: UILabel!
}

final class AssetListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var button: UIButton!
    
    private var balances: NodeService.DTO.AddressAssetsBalance?
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WavesSDK.shared.services
            .nodeServices
            .assetsNodeService
            .assetsBalances(address: "3PCAB4sHXgvtu5NPoen6EXR5yaNbvsEA8Fj")
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (balances) in
                self?.balances = balances
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func actionSend() {
        sendTransaction()
    }
    
    func sendTransaction() {
        
        let seed = "My seed"
        guard let chainId = WavesSDK.shared.enviroment.chainId else { return }
        guard let address = WavesCrypto.shared.address(seed: seed, chainId: chainId) else { return }
        guard let senderPublicKey = WavesCrypto.shared.publicKey(seed: seed) else { return }
        
        
        let recipient = address
        let fee: Int64 = 100000
        let amount: Int64 = 100000
        let feeAssetId = "WAVES"
        let assetId = "WAVES"
        let attachment = ""
        let timestamp = Int64(Date().timeIntervalSince1970) * 1000
        
        var queryModel = NodeService.Query.Transaction.Transfer(recipient: recipient,
                                                                assetId: assetId,
                                                                amount: amount,
                                                                fee: fee,
                                                                attachment: attachment,
                                                                feeAssetId: feeAssetId,
                                                                timestamp: timestamp,
                                                                senderPublicKey: senderPublicKey,
                                                                chainId: chainId)
            queryModel.sign(seed: seed)
        
        let send = NodeService.Query.Transaction.transfer(queryModel)
        
        WavesSDK.shared.services
            .nodeServices
            .transactionNodeService
            .transactions(query: send)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { (tx) in
                print(tx)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UITableViewDataSource

extension AssetListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balances?.balances.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssetCell") as! AssetCell
        
        let balance = self.balances?.balances[indexPath.row]
        
        cell.nameLabel.text = balance?.issueTransaction?.name
        
        let balanceValue = balance?.balance ?? 0
        let decimals = Int(balance?.issueTransaction?.decimals ?? 0)
        
        let value = Decimal(balanceValue) / pow(10, decimals)
        
        cell.balanceLabel.text = "\(value)"
        
        return cell
    }
}
