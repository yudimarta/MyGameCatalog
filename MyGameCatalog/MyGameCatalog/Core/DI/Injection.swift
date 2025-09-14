//
//  Injection.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 13/05/25.
//

import Core
import Foundation
import Game
import Profile

final class Injection: NSObject {
    func provideHome<U: UseCase>() -> U where U.Request == Any, U.Response == [GameModuleDomainModel] {
        
        let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.allGames.url)
        
        let mapper = GameTransformer()
        
        let repository = GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>(
            remoteDataSource: remote,
            mapper: mapper)
        
        return Interactor(repository: repository) as! U
    }
    
    func provideFavorite<U: UseCase>() -> U where U.Request == Any, U.Response == [GameModuleDomainModel] {
        
        let locale = GetGamesLocaleDataSource()
        let mapper = GameTransformer()
        
        let repository = GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>(
            localeDataSource: locale,
            mapper: mapper)
        
        return Interactor(repository: repository) as! U
    }
    
    func provideProfile<U: UseCase>() -> U where U.Request == Any, U.Response == ProfileModuleDomainModel {
        
        let locale = GetProfileLocaleDataSource()
        
        let repository = GetProfileRepository(localeDataSource: locale)
        
        return Interactor(repository: repository) as! U
    }
    
    func provideInsertProfile<U: UseCase>() -> U where U.Request == ProfileModuleEntity, U.Response == Bool {
        
        let locale = GetProfileLocaleDataSource()
        
        let repository = InsertProfileRepository(localeDataSource: locale)
        
        return Interactor(repository: repository) as! U
    }
}
