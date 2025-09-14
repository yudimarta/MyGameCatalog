//
//  FavoritePresenter.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/05/25.
//

import Foundation
import Combine
import Game
import Core
import UIKit

protocol FavoritePresenterProtocol {
    var games: [GameModuleDomainModel] { get set }
    func getFavoriteGames()
    func goToDetail(game: GameModuleDomainModel)
    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { get }
}

class FavoritePresenter: ObservableObject, FavoritePresenterProtocol {
    
    private let router: FavoriteRouterProtocol
    private let useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var games: [GameModuleDomainModel] = []

    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { $games }
    
    var errorMessage: String = ""
    var loadingState: Bool = false
    
    init(useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>, router: FavoriteRouterProtocol) {
        self.useCase = useCase
        self.router = router
    }
    
    func getFavoriteGames() {
        useCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.loadingState = false
                }
            }, receiveValue: { games in
                self.games = games
            })
            .store(in: &cancellables)
    }
    
    func goToDetail(game: GameModuleDomainModel) {
        router.navigateToDetail(with: game)
    }
}

