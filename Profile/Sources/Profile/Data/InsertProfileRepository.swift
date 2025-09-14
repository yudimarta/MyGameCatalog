//
//  InsertProfileRepository.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import Combine
import Core

public struct InsertProfileRepository<
    ProfileLocaleDataSource: LocaleDataSource
>: Repository
where
    ProfileLocaleDataSource.Request == ProfileModuleEntity,
    ProfileLocaleDataSource.Response == ProfileModuleEntity {
    
    public typealias Request = ProfileModuleEntity
    public typealias Response = Bool
    
    private let _localeDataSource: ProfileLocaleDataSource
    
    public init(localeDataSource: ProfileLocaleDataSource) {
        _localeDataSource = localeDataSource
    }
    
    public func execute(request: ProfileModuleEntity?) -> AnyPublisher<Bool, Error> {
        guard let profile = request else {
            return Fail(error: DatabaseError.invalidInstance).eraseToAnyPublisher()
        }
        return _localeDataSource.add(entities: profile)
    }
}