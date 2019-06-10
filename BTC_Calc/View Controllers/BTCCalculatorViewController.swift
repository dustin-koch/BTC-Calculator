//
//  BTCCalculatorViewController.swift
//  BTC_Calc
//
//  Created by Dustin Koch on 6/10/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit

class BTCCalculatorViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var usdTextField: UITextField!
    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var btcTextField: UITextField!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Actions
    @IBAction func usdToBtcTapped(_ sender: Any) {
        guard let usd = usdTextField.text,
            !usd.isEmpty else { return }
        let floatConversion = (usd as NSString).floatValue
        BTCController.sharedInstance.convertUsd(amount: floatConversion) { (answer) in
            DispatchQueue.main.async {
                self.btcLabel.text = String(format: "%.4f", answer)
            }
        }
        updateCurrentPrice()
    }
    @IBAction func btcToUsdTapped(_ sender: Any) {
        guard let btc = btcTextField.text,
            !btc.isEmpty else { return }
        let floatConversion = (btc as NSString).floatValue
        BTCController.sharedInstance.convertBtc(amount: floatConversion) { (answer) in
            DispatchQueue.main.async {
                self.usdLabel.text = String(format: "$%.02f", answer)
            }
        }
        updateCurrentPrice()
    }
    @IBAction func cryTapped(_ sender: Any) {
        presentSimpleInputAlert(title: "What if you decided to HODL", message: "Enter a hypothetical investment from Jan 2013")
    }
    
    func updateCurrentPrice() {
        BTCController.sharedInstance.fetchHourlyPrice { (usd) in
            DispatchQueue.main.async {
                guard let usd = usd else { return }
                self.currentPriceLabel.text = "Current BTC Price: $\(usd.rate)"
            }
        }
    }
    
}//END OF VIEW CONTROLLER

extension BTCCalculatorViewController {
    func presentSimpleInputAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Creating two text fields
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter initial investment in USD"
        }
        //Create actions
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let convertAction = UIAlertAction(title: "Convert Value", style: .default) { (_) in
            guard let investment = alertController.textFields?[0].text,
                !investment.isEmpty else { return }
            let floatInvestment = (investment as NSString).floatValue
            BTCController.sharedInstance.fetchHourlyPrice(completion: { (usd) in
                DispatchQueue.main.async {
                    guard let usd = usd else { return }
                    let multiplier = usd.rateFloat / BTCController.sharedInstance.oldValue
                    let answerString = String(format: "$%.02f", floatInvestment * multiplier)
                    self.currentPriceLabel.text = "Your $\(investment) investment would be\nworth \(answerString) today!"
                }
            })
        }
        //Add actions/present
        alertController.addAction(dismissAction)
        alertController.addAction(convertAction)
        self.present(alertController, animated: true)
    }
}
