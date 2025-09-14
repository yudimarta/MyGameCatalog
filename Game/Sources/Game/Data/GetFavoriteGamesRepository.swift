//
//  GetFavoriteGamesRepository.swift
//  Game
//
//  Created by Yudi Marta on 14/05/25.
//

import Core
import Combine

public struct GetFavoriteGamesRepository<
    GamesLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository
where
GamesLocaleDataSource.Request == String,
GamesLocaleDataSource.Response == GameModuleEntity,
Transformer.Response == GameModuleResponse,
Transformer.Entity == GameModuleEntity,
Transformer.Domain == GameModuleDomainModel
{
    
    public typealias Request = String
    public typealias Response = [GameModuleDomainModel]
    
    private let localeDataSource: GamesLocaleDataSource
    private let mapper: Transformer
    
    public init(
        localeDataSource: GamesLocaleDataSource,
        mapper: Transformer
    ) {
        
        self.localeDataSource = localeDataSource
        self.mapper = mapper
    }
    
    public func execute(request: String?) -> AnyPublisher<[GameModuleDomainModel], any Error> {
        return self.localeDataSource.list()
            .map { self.mapper.mapGameModuleEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
}
