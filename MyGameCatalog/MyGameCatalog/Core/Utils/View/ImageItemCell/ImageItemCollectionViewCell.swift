//
//  ImageItemCollectionViewCell.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/03/25.
//

import UIKit

class ImageItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        screenShotImageView.contentMode = .scaleToFill
        screenShotImageView.clipsToBounds = true
        screenShotImageView.layer.cornerRadius = 16
    }
    
    func configure(with image: String) async {
        let imageDownloader = ImageDownloader()
        guard let url = URL(string: image) else {
            return
        }

        Task {
            do {
                let image = try await imageDownloader.downloadImage(url: url)
                DispatchQueue.main.async {
                    self.screenShotImageView.image = image
                }
            } catch {
                DispatchQueue.main.async {
                    self.screenShotImageView.image = nil
                }
            }
        }
    }


}
