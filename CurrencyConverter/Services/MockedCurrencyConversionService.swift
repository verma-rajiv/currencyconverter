//
//  MockedCurrencyConversionService.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 19/07/22.
//

import Foundation

class MockedCurrencyConversionService: CurrencyConversionServiceProtocol {
    var mockServerUnreachable: Bool = false
    
    private func mockedUSDToINRCurrencyInfo() -> CurrencyInfo {
        return CurrencyInfo(amount: 1.0,
                            base: "USD",
                            date: "04-22-2022",
                            rates: ["INR": 78.902])
    }
    
    private func mockedUSDToJPYCurrencyInfo() -> CurrencyInfo {
        return CurrencyInfo(amount: 10.0,
                            base: "USD",
                            date: "02-21-2022",
                            rates: ["JPY": 100.08])
    }
    
    func convertCurrency(from: String, to: String, amount: Double) async throws -> CurrencyInfo {
        if mockServerUnreachable {
            throw CurrencyConversionServiceError.NotAvailable("The Internet connection appears to be offline.")
        }
        else {
            if (from == "USD" && to == "INR") {
                return mockedUSDToINRCurrencyInfo()
            }
            else if (from == "USD" && to == "JPY") {
                return mockedUSDToJPYCurrencyInfo()
            }
            
            return mockedUSDToINRCurrencyInfo()
        }
    }
    
    func loadCurrencies() async throws -> [Currency] {
        if (mockServerUnreachable)  {
            throw CurrencyConversionServiceError.NotAvailable("The Internet connection appears to be offline.")
        }
        else {            
            return [
                Currency(code: "USD", name: "American Dollar"),
                Currency(code: "INR", name: "Indian Rupee"),
                Currency(code: "AUD", name: "Australian Dollar"),
                Currency(code: "JPY", name: "Japenes Yen"),
            ]
        }
    }
}
