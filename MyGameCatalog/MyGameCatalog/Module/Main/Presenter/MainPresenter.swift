//
//  MainPresenter.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 29/04/25.
//

import Foundation
import Combine
import Game
import UIKit
import Core

protocol MainPresenterProtocol {
    var games: [GameModuleDomainModel] { get set }
    func getGames()
    func goToDetail(game: GameModuleDomainModel)
    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { get }
}

class MainPresenter: ObservableObject, MainPresenterProtocol {
    
    private let router: MainRouterProtocol
    private let useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var games: [GameModuleDomainModel] = []

    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { $games }
    
    var errorMessage: String = ""
    var loadingState: Bool = false
    
    init(useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>, router: MainRouterProtocol) {
        self.useCase = useCase
        self.router = router
    }
    
    func getGames() {
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
