//
//  DetailViewController.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import UIKit
import Combine
import Game

enum Section: Int, CaseIterable {
    case platform
    case screenshot
    case genre
    
    var title: String {
        switch self {
        case .platform: return "Platform"
        case .screenshot: return "Screenshots"
        case .genre: return "Genre"
        }
    }
}

class DetailViewController: UIViewController {
    
    var allGames: [GameModuleDomainModel]?
    
    var presenter: DetailPresenterProtocol!
    
    private var cancellables = Set<AnyCancellable>()
    
    var isFavorite: Bool = false {
        didSet {
            updateFavoriteIcon()
        }
    }
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.presenter = nil
        super.init(coder: coder)
    }
    

    
    private func bindPresenter() {
        presenter.gamesPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] games in
                guard let self else { return }
                
                if let favorite = presenter.favoriteData {
                    let isFavorited = games.contains(where: { $0.id == favorite.id })
                    if self.isFavorite != isFavorited {
                        self.isFavorite = isFavorited
                    }
                }
            }
            .store(in: &cancellables)
        
        presenter.isFavoritePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isFavorite in
                self?.isFavorite = isFavorite
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var sectionTableView: UITableView!
    @IBOutlet weak var likeIconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = presenter.favoriteData?.name
        
        bindPresenter()
        presenter.getFavoriteGames()
        
        detailImageView.contentMode = .scaleToFill
        detailImageView.clipsToBounds = true
        detailImageView.layer.cornerRadius = 16
        
        if let data =  presenter.favoriteData {
            
            URLSession.shared.dataTask(with: data.backgroundImage) { data, _, error in
                if let data = data, error == nil, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.detailImageView.image = image
                    }
                }
            }.resume()
        }
        
        titleLabel.text = presenter.favoriteData?.name
        releaseDateLabel.text = presenter.favoriteData?.released
        ratingLabel.text = String(format: "%.1f", presenter.favoriteData?.rating ?? 0)
        
        likeIconImageView.isUserInteractionEnabled = true
        likeIconImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setFavorite)))
        
        switch floor(presenter.favoriteData?.rating ?? 0.0){
        case 1:
            star1ImageView.image = UIImage(systemName: "star.fill")
        case 2:
            star1ImageView.image = UIImage(systemName: "star.fill")
            star2ImageView.image = UIImage(systemName: "star.fill")
        case 3:
            star1ImageView.image = UIImage(systemName: "star.fill")
            star2ImageView.image = UIImage(systemName: "star.fill")
            star3ImageView.image = UIImage(systemName: "star.fill")
        case 4:
            star1ImageView.image = UIImage(systemName: "star.fill")
            star2ImageView.image = UIImage(systemName: "star.fill")
            star3ImageView.image = UIImage(systemName: "star.fill")
            star4ImageView.image = UIImage(systemName: "star.fill")
        case 5...:
            star1ImageView.image = UIImage(systemName: "star.fill")
            star2ImageView.image = UIImage(systemName: "star.fill")
            star3ImageView.image = UIImage(systemName: "star.fill")
            star4ImageView.image = UIImage(systemName: "star.fill")
            star5ImageView.image = UIImage(systemName: "star.fill")
        default:
            break
        }
        
        sectionTableView.register(UINib(nibName: "TagItemTableViewCell", bundle: nil), forCellReuseIdentifier: "TagItemTableViewCell")
        sectionTableView.dataSource = self
        sectionTableView.delegate = self
    }
    
    @objc func setFavorite() {
        guard let gameData = presenter.favoriteData else { return }

        if presenter.isFavorite {
            presenter.removeGameFavorite(gameData) { [weak self] success in
                DispatchQueue.main.async {
                    self?.showAlert(message: success ? "Removed from Favorite." : "Failed to Remove.")
                    self?.presenter.getFavoriteGames()
                }
            }
        } else {
            presenter.setGameFavorite(gameData) { [weak self] success in
                DispatchQueue.main.async {
                    self?.showAlert(message: success ? "Added to Favorite." : "Failed to Add.")
                    self?.presenter.getFavoriteGames()
                }
            }
        }
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Successful", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    func updateFavoriteIcon() {
        let imageName = presenter.isFavorite ? "heart.fill" : "heart"
        likeIconImageView.image = UIImage(systemName: imageName)
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        switch sectionType {
        case .platform:
            return 1
        case .screenshot:
            return 1
        case .genre:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagItemTableViewCell", for: indexPath) as! TagItemTableViewCell
        
        switch sectionType {
        case .platform:
            cell.configure(with: "Platform", data: presenter.favoriteData?.platforms ?? [], type: .tag)
        case .screenshot:
            cell.configure(with: "Screenshot", data: presenter.favoriteData?.shortScreenshots ?? [], type: .image)
        case .genre:
            cell.configure(with: "Genre", data: presenter.favoriteData?.genres ?? [], type: .tag)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let sectionType = Section(rawValue: indexPath.section) else { return 0 }
        
        switch sectionType {
        case .platform, .genre:
            return 100
        case .screenshot:
            return 200
        }
    }
}
