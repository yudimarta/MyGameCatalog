//
//  APICall.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 29/04/25.
//

import Foundation

struct API {
    
    static let baseUrl = "https://api.rawg.io/api/games"
    
    static var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "RAWG-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'RAWG-Info.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'RAWG-Info.plist'.")
            }
            return value
        }
    }
}

protocol Endpoint {
    
    var url: String { get }
    
}

enum Endpoints {
    
    enum Gets: Endpoint {
        case allGames
        
        public var url: String {
            switch self {
            case .allGames: return "\(API.baseUrl)?key=\(API.apiKey)"
            }
        }
    }
}
