//
//  NetworkServiceProtocol.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 27/07/22.
//

import Foundation

enum NetworkError: Error {
    case Unreachable
    case Unauthorized
    case InternalServerError
    case RequestTimedOut
    case Unknown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .Unreachable:
            return NSLocalizedString(Constants.ErrorMessages.ServerUnreachable, comment: "")
        case .Unauthorized:
            return NSLocalizedString(Constants.ErrorMessages.AccessDenied, comment: "")
        case .InternalServerError:
            return NSLocalizedString(Constants.ErrorMessages.InternalServerError, comment: "")
        case .RequestTimedOut:
            return NSLocalizedString(Constants.ErrorMessages.RequestTimeOut, comment: "")
        default:
            return NSLocalizedString(Constants.ErrorMessages.Unknown, comment: "")
        }
    }
}

protocol NetworkServiceProtocol {    
    func get<T:Decodable>(_ t: T.Type, from url: URL) async throws -> T
}
