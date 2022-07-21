//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 19/07/22.
//

import Foundation


struct Currency: Identifiable, Hashable {
    var id: String { return code }
    var code: String
    var name: String
}
