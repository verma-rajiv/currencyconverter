//
//  CurrencyInfo.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

struct CurrencyInfo: Decodable {
    var amount: Double
    var base: String
    var date: String
    var rates: Dictionary<String, Double>        
}
