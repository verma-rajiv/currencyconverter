//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

import Foundation


enum CurrencyConversionServiceError: Error {
    case InvalidURL
    case IncorrectCurrencyCode
    case NotAvailable(_ message: String)
    case Unknown
}

class CurrencyConversionService: CurrencyConversionServiceProtocol {
    var basePath: String
    
    init(basePath: String = "https://api.frankfurter.app") {
        self.basePath = basePath
    }

    func convertCurrency(from: String, to: String, amount: Double) async throws -> CurrencyInfo {     
        let url = URL(string: "\(basePath)/latest?amount=\(amount)&from=\(from)&to=\(to)")
        guard let url = url else {
            throw CurrencyConversionServiceError.InvalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let currencyInfo =  try JSONDecoder().decode(CurrencyInfo.self, from: data)
                
        return currencyInfo
    }
    
    
    func loadCurrencies() async throws -> [Currency] {
        let url = URL(string: "\(basePath)/currencies")
        guard let url = url else {
            throw CurrencyConversionServiceError.InvalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let currencies =  try JSONDecoder().decode(Dictionary<String, String>.self, from: data)
        let currenciesObjects = currencies.map { (key: String, value: String) in
            Currency(code: key, name: value)
        }
        
        return currenciesObjects
    }
}
