//
//  ProfileTransformer.swift
//  Profile
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation

public final class ProfileTransformer {
    
    public static func mapEntityToDomain(input: ProfileModuleEntity) -> ProfileModuleDomainModel {
        return ProfileModuleDomainModel(
            name: input.name,
            email: input.email,
            photo: input.photo,
            role: input.role,
            site: input.site
        )
    }
    
    public static func mapDomainToEntity(input: ProfileModuleDomainModel) -> ProfileModuleEntity {
        return ProfileModuleEntity(
            email: input.email,
            name: input.name,
            photo: input.photo,
            role: input.role,
            site: input.site
        )
    }
}