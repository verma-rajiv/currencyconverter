//
//  MockedNetworkService.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 27/07/22.
//

import Foundation


class MockedNetworkService: NetworkServiceProtocol {
    var mockedStatusCode: Int = 200
    
    func get<T>(_ t: T.Type, from url: URL) async throws -> T where T : Decodable {
        guard (200...299).contains(mockedStatusCode) else {
            switch(mockedStatusCode) {
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
        
        var response: Data? = nil
        if(url.relativePath.contains("/latest")) {
            let from = getQueryStringParameter(url: url.absoluteString, param: "from")
            let to = getQueryStringParameter(url: url.absoluteString, param: "to")
            var responseString = ""
            if (from == "USD" && to == "INR") {
                responseString = "{\"amount\":1.0,\"base\":\"USD\",\"date\":\"2022-07-27\",\"rates\":{\"INR\":78.90}}"
            }
            else if (from == "USD" && to == "JPY") {
                responseString = "{\"amount\":10.0,\"base\":\"USD\",\"date\":\"2022-07-27\",\"rates\":{\"JPY\":100}}"
            }
            response = Data(responseString.utf8)
        }
        else if(url.relativePath.contains("/currencies")) {
            response = Data("{\"AUD\":\"Australian Dollar\",\"BGN\":\"Bulgarian Lev\",\"BRL\":\"Brazilian Real\",\"CAD\":\"Canadian Dollar\",\"CHF\":\"Swiss Franc\",\"CNY\":\"Chinese Renminbi Yuan\",\"CZK\":\"Czech Koruna\",\"DKK\":\"Danish Krone\",\"EUR\":\"Euro\",\"GBP\":\"British Pound\",\"HKD\":\"Hong Kong Dollar\",\"HRK\":\"Croatian Kuna\",\"HUF\":\"Hungarian Forint\",\"IDR\":\"Indonesian Rupiah\",\"ILS\":\"Israeli New Sheqel\",\"INR\":\"Indian Rupee\",\"ISK\":\"Icelandic Króna\",\"JPY\":\"Japanese Yen\",\"KRW\":\"South Korean Won\",\"MXN\":\"Mexican Peso\",\"MYR\":\"Malaysian Ringgit\",\"NOK\":\"Norwegian Krone\",\"NZD\":\"New Zealand Dollar\",\"PHP\":\"Philippine Peso\",\"PLN\":\"Polish Złoty\",\"RON\":\"Romanian Leu\",\"SEK\":\"Swedish Krona\",\"SGD\":\"Singapore Dollar\",\"THB\":\"Thai Baht\",\"TRY\":\"Turkish Lira\",\"USD\":\"United States Dollar\",\"ZAR\":\"South African Rand\"}".utf8)
        }
        else {
            response = Data("{}".utf8)
        }
        
        return try JSONDecoder().decode(T.self, from: response!)
        
    }
    
    private func getQueryStringParameter(url: String, param: String) -> String? {
        guard let url = URLComponents(string: url) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
      }
}
