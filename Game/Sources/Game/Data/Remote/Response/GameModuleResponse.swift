//
//  GameModuleResponse.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Foundation

public struct GameModuleResponses: Decodable {
    public let count: Int?
    public let next: String?
    public let previous: String?
    public let games: [GameModuleResponse]
    
    public enum CodingKeys: String, CodingKey {
        case count, next, previous
        case games = "results"
    }
}

public struct GameModuleResponse: Decodable {
    public let id: Int
    public let name: String
    public let rating: Double
    public let released: String
    public let backgroundImage: URL
    public let platforms: [PlatformsModuleModel]
    public let genres: [GenresModuleModel]
    public let shortScreenshots: [ShortScreenshotsModuleModel]
    
    public enum CodingKeys: String, CodingKey {
        case id, name, rating, released, platforms, genres
        case backgroundImage = "background_image"
        case shortScreenshots = "short_screenshots"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
    
        let path = try container.decode(String.self, forKey: .backgroundImage)
        backgroundImage = URL(string: path)!
        
        platforms = try container.decodeIfPresent([PlatformsModuleModel].self, forKey: .platforms) ?? []
        genres = try container.decodeIfPresent([GenresModuleModel].self, forKey: .genres) ?? []
        shortScreenshots = try container.decodeIfPresent([ShortScreenshotsModuleModel].self, forKey: .shortScreenshots) ?? []
        
        if let rawDate = try container.decodeIfPresent(String.self, forKey: .released) {
            released = GameModuleResponse.formatDate(rawDate) ?? ""
        } else {
            released = ""
        }
    }
    
    private static func formatDate(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
}

public struct PlatformsModuleModel: Decodable {
    public let platform: PlatformItemModuleModel
}

public struct PlatformItemModuleModel: Decodable {
    public let id: Int
    public let name: String
}

public struct GenresModuleModel: Decodable {
    public let id: Int
    public let name: String
}

public struct ShortScreenshotsModuleModel: Decodable {
    public let id: Int
    public let image: String
}
