//
//  TagItemTableViewCell.swift
//  MyGameCatalog
//
//  Created by Yudi Marta on 03/03/25.
//

import UIKit

enum TypeTagCell: String {
    case tag
    case image
}

class TagItemTableViewCell: UITableViewCell {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        if let layout = tagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
            layout.scrollDirection = .horizontal
        }
        
        tagCollectionView.register(UINib(nibName: "TagItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagItemCollectionViewCell")
        tagCollectionView.register(UINib(nibName: "ImageItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageItemCollectionViewCell")
            
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.isScrollEnabled = true
    }
    
    var item: [String] = [] {
        didSet {
            tagCollectionView.reloadData()
            tagCollectionView.layoutIfNeeded()
        }
    }
    
    var type: TypeTagCell = .tag

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with title: String, data: [String], type: TypeTagCell){
        tagLabel.text = title
        item = data
        self.type = type
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()
            self.tagCollectionView.layoutIfNeeded()
        }
    }
    
 
}

extension TagItemTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.type == .tag {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagItemCollectionViewCell", for: indexPath) as! TagItemCollectionViewCell
            cell.configure(with: item[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageItemCollectionViewCell", for: indexPath) as! ImageItemCollectionViewCell
            
                Task {
                    await cell.configure(with: item[indexPath.row])
                }
                return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if type == .tag{
            let text = item[indexPath.row]
            let font = UIFont.systemFont(ofSize: 12)
            let padding: CGFloat = 16
            let minWidth: CGFloat = 50

            let textWidth = text.size(withAttributes: [.font: font]).width + padding
            let finalWidth = max(textWidth, minWidth)
            
            return CGSize(width: finalWidth, height: 32)
        } else {
            return CGSize(width: 150, height: 100)
        }
    }

}
