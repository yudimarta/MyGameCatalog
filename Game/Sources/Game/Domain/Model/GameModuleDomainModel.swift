//
//  GameModuleDomainModel.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Foundation
import UIKit

public enum GameModuleDownloadState {
    case new, downloaded, failed
}

public class GameModuleDomainModel {
    
    public let id: Int
    public let name: String
    public let rating: Double
    public let released: String
    public let backgroundImage: URL
    public let platforms: [String]
    public let genres: [String]
    public let shortScreenshots: [String]
    
    public var state: GameModuleDownloadState = .new
    public var image: UIImage?
    
    init(id: Int, name: String, rating: Double, released: String, platforms: [String], genres: [String], shortScreenshots: [String], backgroundImage: URL) {
        self.id = id
        self.name = name
        self.rating = rating
        self.released = released
        self.platforms = platforms
        self.genres = genres
        self.shortScreenshots = shortScreenshots
        self.backgroundImage = backgroundImage
    }
}
