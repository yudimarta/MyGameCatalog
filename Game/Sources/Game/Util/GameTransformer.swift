//
//  GameTransformer.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Core
 
public struct GameTransformer: Mapper {
    
    public typealias Response = GameModuleResponse
    public typealias Entity = GameModuleEntity
    public typealias Domain = GameModuleDomainModel
    
    public init() {}
    
    public func mapGameModuleResponseToDomains(
        input response: [GameModuleResponse]
    ) -> [GameModuleDomainModel] {
        return response.map { result in
            return GameModuleDomainModel(id: result.id, name: result.name, rating: result.rating, released: result.released, platforms: result.platforms.map {$0.platform.name}, genres: result.genres.map { $0.name }, shortScreenshots: result.shortScreenshots.map { $0.image }, backgroundImage: result.backgroundImage
        )
      }
    }
    
    public func mapGameModuleEntitiesToDomains(input entity: [GameModuleEntity]) -> [GameModuleDomainModel] {
        return entity.map { result in
            return GameModuleDomainModel(id: result.id, name: result.title, rating: result.rating, released: result.releaseDate, platforms: result.platforms, genres: result.platforms, shortScreenshots: result.genres, backgroundImage: result.posterUrl)
        }
    }
    
    public func mapGameModuleDomainModelToEntity(input domain: GameModuleDomainModel) -> GameModuleEntity {
        return GameModuleEntity(id: domain.id, title: domain.name, rating: domain.rating, releaseDate: domain.released, platforms: domain.platforms, genres: domain.platforms, screenshotURLs: domain.genres, posterUrl: domain.backgroundImage)
    }
}
