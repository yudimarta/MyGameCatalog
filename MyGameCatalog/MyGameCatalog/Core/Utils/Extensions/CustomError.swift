//
//  CustomError.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 29/04/25.
//

import Foundation

enum URLError: LocalizedError {

  case invalidResponse
  case addressUnreachable(URL)
  
  var errorDescription: String? {
    switch self {
    case .invalidResponse: return "Internal Server Error"
    case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
    }
  }

}

enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed
  
  var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Invalid Database Instance"
    case .requestFailed: return "Request Failed"
    }
  }

}
