//
//  FavoriteRouter.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/05/25.
//

import Foundation
import UIKit
import Game

protocol FavoriteRouterProtocol: AnyObject {
    func navigateToDetail(with gameData: GameModuleDomainModel)
    func setViewController(_ viewController: UIViewController)
}

class FavoriteRouter: FavoriteRouterProtocol {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func setViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigateToDetail(with gameData: GameModuleDomainModel) {
        
        let detailUseCase = DependencyContainer.shared.favoriteUseCase
        let detailPresenter = DetailPresenter(useCase: detailUseCase)
        
        let detailVC = DetailViewController(presenter: detailPresenter)
        
        detailPresenter.setGameData(gameData)
        
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
