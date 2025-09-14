//
//  ProfileInitializer.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 13/09/25.
//

import Foundation
import Combine
import Profile
import Core

class ProfileInitializer {
    
    private let injection = Injection()
    private var cancellables = Set<AnyCancellable>()
    
    func insertHardcodedProfile() {
        let insertUseCase: Interactor<ProfileModuleEntity, Bool, InsertProfileRepository<GetProfileLocaleDataSource>> = injection.provideInsertProfile()
        
        let profile = ProfileModuleEntity(
            email: "me@yudimarta.id",
            name: "Yudi Marta Arianto",
            photo: "Profile",
            role: ["iOS Developer", "Web Developer", "Backend Developer"],
            site: "yudimarta.id"
        )
        
        insertUseCase.execute(request: profile)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Failed to insert profile: \(error)")
                    }
                },
                receiveValue: { success in
                    print("Profile inserted: \(success)")
                }
            )
            .store(in: &cancellables)
    }
}