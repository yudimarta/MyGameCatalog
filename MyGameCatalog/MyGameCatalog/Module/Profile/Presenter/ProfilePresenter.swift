//
//  ProfilePresenter.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/05/25.
//

import Foundation
import Combine
import Profile
import Core

protocol ProfilePresenterProtocol {
    var profile: ProfileModuleDomainModel? { get set }
    func getProfile()
    var profilePublisher: Published<ProfileModuleDomainModel?>.Publisher { get }
}

class ProfilePresenter: ObservableObject, ProfilePresenterProtocol {
   
    private let profileUseCase: Interactor<Any, ProfileModuleDomainModel, GetProfileRepository<GetProfileLocaleDataSource>>
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var profile: ProfileModuleDomainModel?

    var profilePublisher: Published<ProfileModuleDomainModel?>.Publisher { $profile }
    
    var errorMessage: String = ""
    var loadingState: Bool = false
    
    init(profileUseCase: Interactor<Any, ProfileModuleDomainModel, GetProfileRepository<GetProfileLocaleDataSource>>) {
        self.profileUseCase = profileUseCase
    }
    
    func getProfile() {
        profileUseCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { profile in
                self.profile = profile
            })
            .store(in: &cancellables)
    }
    
}
