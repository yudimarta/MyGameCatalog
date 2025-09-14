//
//  ProfileViewController.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    var presenter: ProfilePresenterProtocol!
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var roleCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    var role: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        if presenter == nil {
            presenter = DependencyContainer.shared.makeProfilePresenter()
        }
        
        bindPresenter()
       
        profileImageView.contentMode = .scaleToFill
        profileImageView.backgroundColor = .systemBlue
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        roleCollectionView.register(UINib(nibName: "TagItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagItemCollectionViewCell")
            
        roleCollectionView.dataSource = self
        roleCollectionView.delegate = self
        
        if let layout = roleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.scrollDirection = .horizontal
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        roleCollectionView.reloadData()
    }
    
    private func bindPresenter() {
        presenter.profilePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] profile in
                guard let self = self else { return }
                self.nameLabel.text = profile?.name
                self.emailLabel.text = profile?.email
                self.siteLabel.text = profile?.site
                self.profileImageView.image = UIImage(named: profile?.photo ?? "person.circle")
                role = profile?.role ?? []
                self.roleCollectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfile()
    }
    
    private func loadProfile() {
        Task {
            self.presenter.getProfile()
        }
    }

}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return role.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagItemCollectionViewCell", for: indexPath) as! TagItemCollectionViewCell
        cell.configure(with: role[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let text = role[indexPath.row]
            let font = UIFont.systemFont(ofSize: 12)
            let padding: CGFloat = 16
            
            let textWidth = text.size(withAttributes: [.font: font]).width + padding
            return CGSize(width: textWidth, height: 32)
    }

}
