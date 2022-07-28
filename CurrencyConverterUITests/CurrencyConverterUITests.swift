//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Rajiv Verma on 18/07/22.
//

import XCTest

class CurrencyConverterUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launchArguments = ["-runInTestMode"]        
        app.launch()
        
        waitTillProgressViewIsVisible()
        sleep(1)
    }

    func test_default_values() throws {
        // get handle for maount, from and to fields
        let amount = app.textFields["AmountTextField"]
        let fromCurrencyPicker = app.scrollViews.otherElements.buttons["FromCurrencyPicker"]
        let toCurrencyPicker = app.scrollViews.otherElements.buttons["ToCurrencyPicker"]
        
        // assert default values
        XCTAssertEqual(amount.value as? String, "$1.00")
        XCTAssertEqual(fromCurrencyPicker.value as? String, "USD - United States Dollar")
        XCTAssertEqual(toCurrencyPicker.value as? String, "INR - Indian Rupee")
    }
        
    func test_USD_to_INR_conversion() {
        let amount = app.textFields["AmountTextField"]
        amount.tap()
                
        let deleteKey = app/*@START_MENU_TOKEN@*/.keyboards.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
                
        amount.typeText("1.0")
        
        let convertButton = app.buttons["ConvertButton"]
        convertButton.tap()
        
        waitTillProgressViewIsVisible()
        
        let resultText = app.staticTexts["ResultText"]
        XCTAssertEqual(resultText.label,"$1.00 = ₹78.90")
    }
    
    func test_same_currency_error() {
        let fromCurrencyPicker = app.scrollViews.otherElements.buttons["FromCurrencyPicker"]
        let toCurrencyPicker = app.scrollViews.otherElements.buttons["ToCurrencyPicker"]
                                
        fromCurrencyPicker.tap()
        app.collectionViews.buttons["USD - United States Dollar"].tap()
        
        toCurrencyPicker.tap()
        app.collectionViews.buttons["USD - United States Dollar"].tap()
        
        let convertButton = app.buttons["ConvertButton"]
        convertButton.tap()
        
        let errorText = app.staticTexts["ErrorText"]
        XCTAssertEqual(errorText.label,"from and to fields can't be same")
    }
    
    func test_symbol_change_in_amount_when_from_field_changes () {
        let fromCurrencyPicker = app.scrollViews.otherElements.buttons["FromCurrencyPicker"]
        let amount = app.textFields["AmountTextField"]
        
        XCTAssertTrue((amount.value as! String).contains("$"))
        
        fromCurrencyPicker.tap()
        app.collectionViews.buttons["MXN - Mexican Peso"].tap()
                
        XCTAssertTrue((amount.value as! String).contains("MX$"))
        
    }
    
    
    func waitTillProgressViewIsVisible () {
        let progress = app.progressIndicators["ProgressView"]
        let doesNotExistPredicate = NSPredicate(format: "exists == FALSE")
         expectation(for: doesNotExistPredicate, evaluatedWith: progress, handler: nil)
         waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
