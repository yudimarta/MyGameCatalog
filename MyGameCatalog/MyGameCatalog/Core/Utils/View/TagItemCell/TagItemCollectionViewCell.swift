//
//  TagItemCollectionViewCell.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/03/25.
//

import UIKit

class TagItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 16
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.masksToBounds = true
    }
    
    func configure(with text: String){
        tagLabel.text = text
    }

}
