//
//  DependencyContainer.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 13/05/25.
//

import Foundation
import Core
import Game
import Profile

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    private init() {}
    

    lazy var homeUseCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>> = {
        return Injection().provideHome()
    }()
    
    lazy var favoriteUseCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>> = {
        return Injection().provideFavorite()
    }()
    
    lazy var profileUseCase: Interactor<Any, ProfileModuleDomainModel, GetProfileRepository<GetProfileLocaleDataSource>> = {
        return Injection().provideProfile()
    }()
    

    func makeMainPresenter() -> MainPresenterProtocol {
        let router = makeMainRouter()
        return MainPresenter(useCase: homeUseCase, router: router)
    }
    
    func makeMainRouter() -> MainRouterProtocol {
        return MainRouter()
    }
    

    func makeFavoritePresenter() -> FavoritePresenterProtocol {
        let router = makeFavoriteRouter()
        return FavoritePresenter(useCase: favoriteUseCase, router: router)
    }
    
    func makeFavoriteRouter() -> FavoriteRouterProtocol {
        return FavoriteRouter()
    }
    

    func makeProfilePresenter() -> ProfilePresenterProtocol {
        return ProfilePresenter(profileUseCase: profileUseCase)
    }
}
