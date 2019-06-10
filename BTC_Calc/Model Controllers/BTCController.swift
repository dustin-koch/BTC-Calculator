//
//  BTCController.swift
//  BTC_Calc
//
//  Created by Dustin Koch on 6/10/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation

class BTCController {
    
    //MARK: - Singleton
    static let sharedInstance = BTCController()
    private init() {}
    
    //MARK: - Properties
    var usdInfo: USD?
    let exchangeURL = "https://api.coindesk.com/v1/bpi/currentprice.json"
    let oldValue: Float = 13.5
    
    
    //MARK: - CRUD Functions
    func fetchHourlyPrice(completion: @escaping (USD?) -> Void) {
        guard let url = URL(string: exchangeURL) else { completion(nil); return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            guard let data = data else { completion(nil); return }
            let jsonDecoder = JSONDecoder()
            do {
                let topLevelDictionary = try jsonDecoder.decode(TopLevelJSONDictionary.self, from: data)
                let usd = topLevelDictionary.bpi.usd
                self.usdInfo = usd
                completion(usd)
            } catch {
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }.resume()
    }
}//END OF CLASS

extension BTCController {
    func convertUsd(amount: Float, completion: @escaping (Float) -> Void){
        var answer: Float = 0.0
        fetchHourlyPrice { (rate) in
            guard let rate = rate else { return }
            answer = (amount / rate.rateFloat)
            completion(answer)
        }
    }
}

extension BTCController {
    func convertBtc(amount: Float, completion: @escaping (Float) -> Void) {
        var answer: Float = 0.0
        fetchHourlyPrice { (rate) in
            guard let rate = rate else { return }
            answer = (amount * rate.rateFloat)
            completion(answer)
        }
    }
}
