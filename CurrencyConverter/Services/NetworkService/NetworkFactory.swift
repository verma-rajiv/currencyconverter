//
//  NetworkFactory.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 28/07/22.
//

import Foundation


class NetworkFactory {
    static let shared = NetworkFactory()
    
    private init() {}
    
    public func getNetworkService() -> NetworkServiceProtocol  {
        let isTestModeON = ProcessInfo.processInfo.arguments.contains("-runInTestMode")
        return isTestModeON ? NetworkService() : MockedNetworkService()
    }
}
