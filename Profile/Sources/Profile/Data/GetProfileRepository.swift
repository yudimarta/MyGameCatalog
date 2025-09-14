//
//  GetProfileRepository.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import Combine
import Core

public struct GetProfileRepository<
    ProfileLocaleDataSource: LocaleDataSource
>: Repository
where
    ProfileLocaleDataSource.Request == ProfileModuleEntity,
    ProfileLocaleDataSource.Response == ProfileModuleEntity {
    
    public typealias Request = Any
    public typealias Response = ProfileModuleDomainModel
    
    private let _localeDataSource: ProfileLocaleDataSource
    
    public init(localeDataSource: ProfileLocaleDataSource) {
        _localeDataSource = localeDataSource
    }
    
    public func execute(request: Any?) -> AnyPublisher<ProfileModuleDomainModel, Error> {
        return _localeDataSource.list()
            .compactMap { $0.first }
            .map { ProfileTransformer.mapEntityToDomain(input: $0) }
            .eraseToAnyPublisher()
    }
}