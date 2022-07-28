//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 27/07/22.
//

import Foundation

class NetworkService : NetworkServiceProtocol {    
    func get<T:Decodable>(_ t: T.Type, from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)
        let httpURLResponse = response as! HTTPURLResponse
        let statusCode = httpURLResponse.statusCode
        
        guard (200...299).contains(statusCode) else {
            switch(statusCode) {
            case 500:
                throw NetworkError.InternalServerError
            case 503:
                throw NetworkError.Unreachable
            case 401:
                throw NetworkError.Unauthorized
            case 408:
                throw NetworkError.RequestTimedOut
            default:
                throw NetworkError.Unknown
            }
        }
        
        let value =  try JSONDecoder().decode(T.self, from: data)
        return value
    }        
}
