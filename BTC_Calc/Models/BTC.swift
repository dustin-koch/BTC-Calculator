//
//  BTC.swift
//  BTC_Calc
//
//  Created by Dustin Koch on 6/10/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation

struct TopLevelJSONDictionary : Decodable {
    let bpi: BPI
}

struct BPI: Decodable {
    let usd: USD
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct USD: Decodable {
    let rate: String
    let rateFloat: Float
    
    enum CodingKeys: String, CodingKey {
        case rate
        case rateFloat = "rate_float"
    }
}


