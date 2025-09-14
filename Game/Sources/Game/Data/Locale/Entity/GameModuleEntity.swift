//
//  HomeModuleEntity.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Foundation
import UIKit

public class GameModuleEntity {
    let id: Int
    let title: String
    let rating: Double
    let releaseDate: String
    let platforms: [String]
    let genres: [String]
    let screenshotURLs: [String]
    let posterUrl: URL
    
    var image: UIImage?
    
    init(id: Int, title: String, rating: Double, releaseDate: String, platforms: [String], genres: [String], screenshotURLs: [String], posterUrl: URL) {
        self.id = id
        self.title = title
        self.rating = rating
        self.releaseDate = releaseDate
        self.platforms = platforms
        self.genres = genres
        self.screenshotURLs = screenshotURLs
        self.posterUrl = posterUrl
    }
    
    convenience init(from game: GameModuleResponse) {
        self.init(
            id: game.id,
            title: game.name,
            rating: game.rating,
            releaseDate: game.released,
            platforms: game.platforms.compactMap { $0.platform.name },
            genres: game.genres.compactMap { $0.name },
            screenshotURLs: game.shortScreenshots.compactMap { $0.image },
            posterUrl: game.backgroundImage
        )
    }
}
