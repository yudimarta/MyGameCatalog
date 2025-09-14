//
//  AddFavoriteGamesRepository.swift
//  Game
//
//  Created by Yudi Marta on 14/05/25.
//

import Core
import Combine

public struct AddFavoriteGamesRepository<
    GamesLocaleDataSource: LocaleDataSource,
    Transformer: Mapper
>: Repository
where
GamesLocaleDataSource.Request == GameModuleEntity,
GamesLocaleDataSource.Response == GameModuleEntity,
Transformer.Response == GameModuleResponse,
Transformer.Entity == GameModuleEntity,
Transformer.Domain == GameModuleDomainModel
{
    
    
    public typealias Request = GameModuleDomainModel
    public typealias Response = Bool
    
    private let localeDataSource: GamesLocaleDataSource
    private let mapper: Transformer
    
    public init(
        localeDataSource: GamesLocaleDataSource,
        mapper: Transformer
    ) {
        
        self.localeDataSource = localeDataSource
        self.mapper = mapper
    }
    
    public func execute(request: GameModuleDomainModel?) -> AnyPublisher<Bool, any Error> {
        if let request = request {
            let game = self.mapper.mapGameModuleDomainModelToEntity(input: request)
            return self.localeDataSource.add(entities: game)
                .map { _ in true }.eraseToAnyPublisher()
        }
        return Fail(error: DatabaseError.invalidInstance)
                .eraseToAnyPublisher()
    }
}
