//
//  Constants.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 21/07/22.
//

import Foundation

struct Constants {
    struct Labels {
        static let navigationHeader = "Currency Converter"
        static let amountLabel = "Enter Amount"
        static let fromLabel = "Convert from"
        static let toLabel = "Convert to"
        static let convertButtonLabel = "Convert"
        static let fromPickerLabel = "Select the currency you want to convert"
        static let toPickerLabel = "Select the target currrency"
    }
    struct ErrorMessages {
        static let amountGreaterThanZeroMessage = "please enter an amount greater than zero"
        static let sameCurrencySymbolsErrorMessage = "from and to fields can't be same"
    }
}
