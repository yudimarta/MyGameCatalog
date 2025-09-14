//
//  GetGamesRepository.swift
//  Home
//
//  Created by Yudi Marta on 13/05/25.
//

import Core
import Combine
import Foundation

public struct GetGamesRepository<GameLocaleDataSource: LocaleDataSource, RemoteDataSource: DataSource, Transformer: Mapper>: Repository
where GameLocaleDataSource.Response == GameModuleEntity, RemoteDataSource.Response == [Transformer.Response],
        Transformer.Domain == GameModuleDomainModel, Transformer.Entity == GameModuleEntity {
  
    public typealias Request = Any
    public typealias Response = [GameModuleDomainModel]
    
    private let _localeDataSource: GameLocaleDataSource?
    private let _remoteDataSource: RemoteDataSource?
    private let _mapper: Transformer
    
    public init(
        localeDataSource: GameLocaleDataSource? = nil,
        remoteDataSource: RemoteDataSource? = nil,
        mapper: Transformer) {

        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Any?) -> AnyPublisher<[GameModuleDomainModel], Error> {
        if let remoteDataSource = _remoteDataSource {
            return remoteDataSource.execute(request: nil)
                .map { _mapper.mapGameModuleResponseToDomains(input: $0) }
                .eraseToAnyPublisher()
        } else if let localeDataSource = _localeDataSource {
            return localeDataSource.list()
                .map { entities in
                    _mapper.mapGameModuleEntitiesToDomains(input: entities)
                }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "No data source available", code: -1))
                .eraseToAnyPublisher()
        }
    }
}
