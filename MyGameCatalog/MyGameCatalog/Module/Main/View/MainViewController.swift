//
//  ViewController.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import Foundation
import UIKit
import Combine
import Core
import Game

class MainViewController: UIViewController {
    
    private var presenter: MainPresenterProtocol!
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var gameTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        registerCell()
        bindPresenter()
        gameTableView.reloadData()
    }
    
    private func setupPresenter() {
        presenter = DependencyContainer.shared.makeMainPresenter()
        // Set the view controller reference in the router
        let router = DependencyContainer.shared.makeMainRouter()
        router.setViewController(self)
        presenter = MainPresenter(useCase: DependencyContainer.shared.homeUseCase, router: router)
    }
    
    private func bindPresenter() {
        presenter.gamesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.gameTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Refresh", style: .default) { _ in
            Task {
                self.presenter.getGames()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            self.presenter.getGames()
            DispatchQueue.main.async {
                self.gameTableView.reloadData()
            }
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell {
            
            let game = presenter.games[indexPath.row]
            cell.config(data: game)
            
            
            if game.state == .new {
                cell.loadingIndicator.isHidden = false
                cell.loadingIndicator.startAnimating()
                startOperations(game: game, indexPath: indexPath)
            } else {
                cell.loadingIndicator.stopAnimating()
                cell.loadingIndicator.isHidden = true
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

