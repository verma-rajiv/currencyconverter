//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

import Foundation


enum CurrencyConversionServiceError: Error {
    case InvalidURL    
}


extension CurrencyConversionServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .InvalidURL:
            return NSLocalizedString(Constants.ErrorMessages.InvalidURL, comment: "")
        }
    }
}

class CurrencyConversionService: CurrencyConversionServiceProtocol {
    var networkService: NetworkServiceProtocol
    var basePath: String
    
    init(networkService: NetworkServiceProtocol = NetworkFactory.shared.getNetworkService(),
         basePath: String = Constants.NetworkConfig.basePath) {
        self.networkService = networkService
        self.basePath = basePath
    }
    
    func convertCurrency(from: String, to: String, amount: Double) async throws -> CurrencyInfo {
        let url = URL(string: "\(basePath)/latest?amount=\(amount)&from=\(from)&to=\(to)")
        guard let url = url else {
            throw CurrencyConversionServiceError.InvalidURL
        }
        
        let currencyInfo: CurrencyInfo = try await self.networkService.get(CurrencyInfo.self, from: url)
        return currencyInfo
    }
    
    
    func loadCurrencies() async throws -> [Currency] {
        let url = URL(string: "\(basePath)/currencies")
        guard let url = url else {
            throw CurrencyConversionServiceError.InvalidURL
        }
        
        let currencies = try await self.networkService.get(Dictionary<String, String>.self, from: url)
        
        // traverse the currencies to generate Currency Model Objects
        let currenciesObjects = currencies.map { (key: String, value: String) in
            Currency(code: key, name: value)
        }
        
        return currenciesObjects
    }
}
