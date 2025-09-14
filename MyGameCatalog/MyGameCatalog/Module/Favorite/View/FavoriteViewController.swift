//
//  ProfileViewController.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import Foundation
import UIKit
import Combine
import Game

class FavoriteViewController: UIViewController {
    private var presenter: FavoritePresenterProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var gameTableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite Games"
        setupPresenter()
        emptyLabel.isHidden = true
        registerCell()
        bindPresenter()
    }
    
    private func setupPresenter() {
        // Set the view controller reference in the router
        let router = DependencyContainer.shared.makeFavoriteRouter()
        router.setViewController(self)
        presenter = FavoritePresenter(useCase: DependencyContainer.shared.favoriteUseCase, router: router)
    }
    
    private func bindPresenter() {
        presenter.gamesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                let isEmpty = self.presenter?.games.isEmpty ?? true
                self.emptyLabel.isHidden = !isEmpty
                self.gameTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavoriteGames()
    }
    
    private func loadFavoriteGames() {
        Task {
            self.presenter.getFavoriteGames()
        }
    }
    
    private func registerCell() {
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameTableViewCell")
    }
    
    fileprivate func startOperations(game: GameModuleDomainModel, indexPath: IndexPath){
        if game.state == .new {
            startDownload(game: game, indexPath: indexPath)
        }
    }
    
    fileprivate func startDownload(game: GameModuleDomainModel, indexPath: IndexPath){
        let imageDownloader = ImageDownloader()
        if game.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage)
                    game.state = .downloaded
                    game.image = image
                    self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
    
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.games.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell {
            
            let game = presenter?.games[indexPath.row]
            cell.config(data: game)
            
            if let game = game {
                if game.state == .new {
                    cell.loadingIndicator.isHidden = false
                    cell.loadingIndicator.startAnimating()
                    startOperations(game: game, indexPath: indexPath)
                } else {
                    cell.loadingIndicator.stopAnimating()
                    cell.loadingIndicator.isHidden = true
                }
            }
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameData = presenter.games[indexPath.row]
        presenter.goToDetail(game: gameData)
    }
}
