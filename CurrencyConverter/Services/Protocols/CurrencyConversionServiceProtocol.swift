//
//  CurrencyConversionServiceProtocol.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

import Foundation


protocol CurrencyConversionServiceProtocol {
    ///    This function converts the given amount to the target currency.
    ///
    ///     - Parameters:
    ///          - amount: The amount to be converted.
    ///          - from: The source currency code (See [loadCurrencies]() method which provides currency codes).
    ///          - to: The target currency code.
    ///    - Returns:currencyInfo - The response wrapper class containing information about converted rate.
    ///    - Throws: Please see [CurrencyConversionServiceError]()
    func convertCurrency(from: String, to: String, amount: Double) async throws -> CurrencyInfo
    
    ///    This function provides the list of currency symbols along with their full names.
    ///    - Returns:An array containing Currency objects with currency code and currency names
    ///    - Throws: CurrencyConversionServiceError if the server is unreachable.
    func loadCurrencies() async throws -> [Currency]
}
