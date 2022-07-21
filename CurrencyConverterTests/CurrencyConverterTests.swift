//
//  CurrencyConverterTests.swift
//  CurrencyConverterTests
//
//  Created by Rajiv Verma on 18/07/22.
//

import XCTest
@testable import CurrencyConverter
import SwiftUI

class CurrencyConverterTests: XCTestCase {
    private var viewModel:CurrencyConversionViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CurrencyConversionViewModel(service: MockedCurrencyConversionService())
    }
    
    func test_currencies_are_loaded_successfully() {
        var currencies: [Currency] = []
        let expectation = XCTestExpectation(description: "Waiting for currencies to load successfully")
        let subscribe = viewModel.$currencies.dropFirst().sink { completion in
            // not for our use
        } receiveValue: { value in
            guard value.count > 0 else { return }
            currencies = value
            expectation.fulfill()
        }
        viewModel.loadCurrencies()
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(currencies.count, 4)
        subscribe.cancel()
    }
    
    func test_error_when_server_not_reachable_while_loading_currencies() {
        let currenyService = MockedCurrencyConversionService()
        currenyService.mockServerUnreachable = true
        let viewModel = CurrencyConversionViewModel(service: currenyService)
        
        let expectedErrorMessage = "The operation couldn’t be completed. (CurrencyConverter.CurrencyConversionServiceError error 0.)"
        var actualErrorMessage: String? = ""
        let expectation = XCTestExpectation(description: "Waiting for currencies service to fail because of network error")
        
        let subscribe = viewModel.$errorMessage.sink { completion in
            // not for our use
            //expectation.fulfill()
        } receiveValue: { value in
            guard value != nil else { return }
            actualErrorMessage  = value
            expectation.fulfill()
        }
        viewModel.loadCurrencies()
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(actualErrorMessage, expectedErrorMessage)
        subscribe.cancel()
    }
    
    
    func test_error_when_server_not_reachable_while_conversion_call () {
        let currenyService = MockedCurrencyConversionService()
        currenyService.mockServerUnreachable = true
        let viewModel = CurrencyConversionViewModel(service: currenyService)
        
        let expectedErrorMessage = "The operation couldn’t be completed. (CurrencyConverter.CurrencyConversionServiceError error 0.)"
        var actualErrorMessage: String? = ""
        let expectation = XCTestExpectation(description: "Waiting for conversion service to fail because of network error")
        
        let subscribe = viewModel.$errorMessage.sink { completion in
            // not for our use
            //expectation.fulfill()
        } receiveValue: { value in
            guard value != nil else { return }
            actualErrorMessage  = value
            expectation.fulfill()
        }
        viewModel.convert(amount: 1.0, from: "USD", to: "INR")
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(actualErrorMessage, expectedErrorMessage)
        subscribe.cancel()
    }
    
    func test_conversion_of_1_USD_to_7890_INR() {
        let expectedResult = "$1.00 = ₹78.90"
        var actualResult: String? = ""
        let expectation = XCTestExpectation(description: "Waiting for conversion from USD to INR")
        
        let subscribe = viewModel.$currencyConversionResult.sink { completion in
            // not for our use
            //expectation.fulfill()
        } receiveValue: { value in
            guard value != "" else { return }
            actualResult  = value
            expectation.fulfill()
        }
        viewModel.from = "USD"
        viewModel.to = "INR"
        viewModel.amount = 1.0
        viewModel.convert(amount: 1.0, from: "USD", to: "INR")
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(actualResult, expectedResult)
        
        subscribe.cancel()
    }
    
    func test_conversion_of_10_USD_to_100_JPY() {
        let expectedResult = "$10.00 = ¥100."
        var actualResult: String? = ""
        let expectation = XCTestExpectation(description: "Waiting for conversion from USD to JPY")
        
        viewModel.from = "USD"
        viewModel.to = "JPY"
        viewModel.amount = 10.0
        
        let subscribe = viewModel.$currencyConversionResult.dropFirst().sink { completion in
            // not for our use
            //expectation.fulfill()
        } receiveValue: { value in
            guard value != "" else { return }
            actualResult  = value
            expectation.fulfill()
        }
      
        viewModel.convert(amount: 10.00, from: "USD", to: "JPY")
        
        wait(for: [expectation], timeout: 13)
        XCTAssertEqual(actualResult, expectedResult)
        
        subscribe.cancel()
    }
    
    func test_amount_from_to_validation() {
        viewModel.convert(amount: 0.0, from: "USD", to: "INR")
        XCTAssertEqual(viewModel.errorMessage, "please enter an amount greater than zero")
        
        viewModel.convert(amount: 234, from: "INR", to: "INR")
        XCTAssertEqual(viewModel.errorMessage, "from and to fields can't be same")
        
        viewModel.convert(amount: 234, from: "JPY", to: "INR")
        XCTAssertNil(viewModel.errorMessage)        
    }
    
}
