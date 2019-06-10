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
    
    
    //MARK: - CRUD Functions
    func fetchHourlyPrice(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: exchangeURL) else { completion(false); return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let data = data else { completion(false); return }
            let jsonDecoder = JSONDecoder()
            do {
                let topLevelDictionary = try jsonDecoder.decode(TopLevelJSONDictionary.self, from: data)
                let usd = topLevelDictionary.bpi.usd
                self.usdInfo = usd
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
                return
            }
        }.resume()
    }
}//END OF CLASS
