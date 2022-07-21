//
//  CurrencyConversionViewModel.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

import Foundation
import SwiftUI


final class CurrencyConversionViewModel: ObservableObject {
    private var service: CurrencyConversionServiceProtocol
    private var currencyInfo: CurrencyInfo? {
        didSet {
            guard let currencyInfo = currencyInfo else {
                self.currencyConversionResult = ""
                return
            }
            
            // apply formatter on the the currency info to display results
            let lhs = NSNumber(value:currencyInfo.amount)
            let rhs = NSNumber(value: currencyInfo.rates[to]!)
            let lhsString = currencyFormatter.string(from: lhs)!
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.usesGroupingSeparator = true
            formatter.alwaysShowsDecimalSeparator = true
            formatter.currencyCode = to
            let rhsString = formatter.string(from: rhs)!
            
            self.currencyConversionResult = "\(lhsString) = \(rhsString)"
        }
    }
        
    @Published var isLoading: Bool = false
    @Published var amount: Double
    @Published var from: String {
        didSet {
            self.currencyFormatter.currencyCode = from
        }
    }
    @Published var to: String
    
    /// The string value for the view to display currency conversion results.
    @Published var currencyConversionResult: String
    @Published var errorMessage: String?
    @Published var currencies: [Currency] = []
    
    /// The formatter for currency amount. It uses NumberFormatter to display the currency amount with appropriate currency symbols and grouping.
    var currencyFormatter: NumberFormatter
    
    init(service: CurrencyConversionServiceProtocol = CurrencyConversionService()) {
        let mode = ProcessInfo.processInfo.arguments.contains("-runInTestMode")
        self.service = mode ? MockedCurrencyConversionService() : service 
        self.amount = 1
        self.from = "USD"
        self.to = "INR"
        self.currencyConversionResult = ""
                
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.alwaysShowsDecimalSeparator = true
        formatter.allowsFloats = true
        
        self.currencyFormatter = formatter
    }
    
    ///    This function converts the given amount to the target currency.
    ///
    ///    This function sets the result in [currencyInfo]() variable which should be observed for changes. In case of error, it sets the [errorMessage]() variable.
    ///     - Parameters:
    ///          - amount: The amount to be converted.
    ///          - from: The source currency code (See [loadCurrencies]() method which provides currency codes).
    ///          - to: The target currency code.
    func convert(amount: Double, from: String, to: String) -> Void {
        // reset any previously set error message and result
        self.errorMessage = nil
        self.currencyConversionResult = ""
        self.currencyInfo = nil
           
        guard  amount > 0.0 else {
            self.errorMessage = "please enter an amount greater than zero"
            return
        }
        
        guard from != to else {
            self.errorMessage = "from and to fields can't be same"
            return
        }
        
        self.isLoading = true
        
        Task.detached {
            do {
                let currencyInfo = try await self.service.convertCurrency(from: from, to: to, amount: amount)
                await MainActor.run {
                    self.currencyInfo = currencyInfo
                    self.isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
///    This function loads the list of currency symbols along with their full names. It sets the results in [currencies]() which should be observed for changes.
    func loadCurrencies() -> Void {
        self.isLoading = true
        Task.detached {
            do {
                let currencies = try await self.service.loadCurrencies()
                await MainActor.run {
                    self.currencies = currencies.sorted { c1, c2 in
                        c1.name < c2.name
                    }
                    
                    self.isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    self.currencies = []
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

