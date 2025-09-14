//
//  GameTableViewCell.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 02/03/25.
//

import UIKit
import Game

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gameImageView.contentMode = .scaleToFill
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 16
    }

    func config(data: GameModuleDomainModel?) {
        guard let game = data else {
            return
        }
        
        gameLabel.text = game.name
        releaseLabel.text = game.released
        gameImageView.image = game.image
        ratingLabel.text = "\(game.rating)"
        
        switch floor(game.rating){
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
    }
}
