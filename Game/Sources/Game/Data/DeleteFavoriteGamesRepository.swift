//
//  DeleteFavoriteGamesRepository.swift
//  Game
//
//  Created by Yudi Marta on 14/05/25.
//

import Core
import Combine

public struct DeleteFavoriteGamesRepository<
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
            return self.localeDataSource.delete(request.id)
                .map { _ in true }.eraseToAnyPublisher()
        }
        return Fail(error: DatabaseError.invalidInstance)
                .eraseToAnyPublisher()
    }
}
