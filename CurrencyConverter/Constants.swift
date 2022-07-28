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
        
        static let InvalidURL = "Invalid URL"
        static let InternalServerError = "Internal Server Error"
        static let ServerUnreachable = "Service Unreachable. Please try after sometime!"
        static let AccessDenied = "Access Denied. Please make sure you are authorized to access this service."
        static let RequestTimeOut = "Server is unable to process the request. Most of the time this is temporary issue. Please try again!"
        static let Unknown = "Something went wrong. Please report this issue by sending an email to admin@currencyconverter.com"
        
    }
    struct Currencies {
        static let USD = "USD"
        static let INR = "INR"
    }
    struct NetworkConfig {
        static let basePath = "https://api.frankfurter.app"
    }
}
