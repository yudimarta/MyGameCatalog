//
//  DetailPresenter.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/05/25.
//

import Foundation
import Combine
import Game
import Core

protocol DetailPresenterProtocol {
    var favoriteData: GameModuleDomainModel? { get set }
    var games: [GameModuleDomainModel] { get set }
    var isFavorite: Bool { get set }
    func getFavoriteGames()
    func setGameFavorite(_ game: GameModuleDomainModel, completion: @escaping (Bool) -> Void)
    func removeGameFavorite(_ game: GameModuleDomainModel, completion: @escaping (Bool) -> Void)
    func setGameData(_ gameData: GameModuleDomainModel)
    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { get }
    var isFavoritePublisher: Published<Bool>.Publisher { get }
}

class DetailPresenter: DetailPresenterProtocol {
    
    var favoriteData: GameModuleDomainModel? = nil
    private let useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>
    
    @Published var games: [GameModuleDomainModel] = []
    @Published var isFavorite: Bool = false
    
    var gamesPublisher: Published<[GameModuleDomainModel]>.Publisher { $games }
    var isFavoritePublisher: Published<Bool>.Publisher { $isFavorite }
    
    
    var errorMessage: String = ""
    private var cancellables: Set<AnyCancellable> = []
    
    init(useCase: Interactor<Any, [GameModuleDomainModel], GetGamesRepository<GetGamesLocaleDataSource, GetGamesRemoteDataSource, GameTransformer>>) {
        self.useCase = useCase
    }
    
    func getFavoriteGames() {
        useCase.execute(request: nil)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    break
                }
            }, receiveValue: { games in
                self.games = games
                if let favorite = self.favoriteData {
                    self.isFavorite = games.contains(where: { $0.id == favorite.id })
                }
            })
            .store(in: &cancellables)
    }
    
    func setGameFavorite(_ game: GameModuleDomainModel, completion: @escaping (Bool) -> Void) {
        let locale = GetGamesLocaleDataSource()
        let mapper = GameTransformer()
        let entity = mapper.mapGameModuleDomainModelToEntity(input: game)
        
        locale.add(entities: entity)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { success in
                self.isFavorite = success
                completion(success)
            })
            .store(in: &cancellables)
    }
    
    func removeGameFavorite(_ game: GameModuleDomainModel, completion: @escaping (Bool) -> Void) {
        let locale = GetGamesLocaleDataSource()
        
        locale.delete(game.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { success in
                self.isFavorite = !success
                completion(success)
            })
            .store(in: &cancellables)
    }
    
    func setGameData(_ gameData: GameModuleDomainModel) {
        self.favoriteData = gameData
        getFavoriteGames()
    }
}
