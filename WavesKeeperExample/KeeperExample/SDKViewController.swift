//  Copyright © 2019 Waves. All rights reserved.
//

import UIKit
import WavesSDK
import RxSwift
import WavesSDKCrypto

final class SDKViewController: UIViewController {

    private var currentServer: WavesEnvironment.Server!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var labelInfo: UILabel!
    @IBOutlet private weak var acitivityIndicatorBalance: UIActivityIndicatorView!
    @IBOutlet private weak var buttonLoadBalance: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "My Waves dApp"
        labelInfo.text = nil 
        acitivityIndicatorBalance.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentServer = WavesSDK.shared.enviroment.server
        setupButton()
    }
    
    @IBAction private func generateNewSeed(_ sender: Any) {
        let seed = WavesCrypto.shared.randomSeed()
        self.setupInfo(title: "New seed is:", value: seed)
    }
    
    @IBAction private func loadWavesBalance(_ sender: Any) {
        
        guard let address = WavesCrypto.shared.address(seed: "", chainId: WavesSDK.shared.enviroment.chainId) else { return }

        self.buttonLoadBalance.isEnabled = false
        self.buttonLoadBalance.setTitle(nil, for: .normal)
        self.acitivityIndicatorBalance.isHidden = false
        self.acitivityIndicatorBalance.startAnimating()
        
        WavesSDK.shared.services
            .nodeServices
            .addressesNodeService
            .addressBalance(address: address)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (balance) in
                guard let self = self else { return }
                self.setupInfo(title: "Balance is:", value: String(balance.balance))
                self.setupDefaultButtonBalanceState()
                
            }, onError: { [weak self] (error) in
                
                guard let self = self else { return }
                self.setupDefaultButtonBalanceState()
                
                let vc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                vc.addAction(cancel)
                self.present(vc, animated: true, completion: nil)

            }).disposed(by: disposeBag)
    }
    
    
    @objc private func changeNetwork() {
        if currentServer.isMainNet {
            currentServer = .testNet
        }
        else {
            currentServer = .mainNet
        }
        setupButton()
        WavesSDK.initialization(servicesPlugins: .init(data: [], node: [], matcher: []), enviroment: .init(server: currentServer, timestampServerDiff: 0))
    }
}

private extension SDKViewController {
    
    func setupDefaultButtonBalanceState() {
        self.acitivityIndicatorBalance.stopAnimating()
        self.acitivityIndicatorBalance.isHidden = true
        self.buttonLoadBalance.isEnabled = true
        self.buttonLoadBalance.setTitle("Load address Waves balance", for: .normal)
    }
    
    func setupInfo(title: String, value: String) {
        
        let text = title + " " + value
        
        let attr = NSMutableAttributedString(string: text)
        attr.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: labelInfo.font.pointSize)],
                           range: (text as NSString).range(of: title))
        labelInfo.attributedText = attr
    }
    
    func setupButton() {
        let buttonTitle = currentServer.isMainNet ? "MainNet" : "TestNet"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(changeNetwork))
    }
}

extension WavesEnvironment.Server {
    var isMainNet: Bool {
        switch self {
        case .mainNet:
            return true
        default:
            return false
        }
    }
}
