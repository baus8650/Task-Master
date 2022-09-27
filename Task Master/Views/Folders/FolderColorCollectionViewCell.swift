//
//  FolderColorCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import UIKit

class FolderColorCollectionViewCell: UICollectionViewCell {
    
    var color: UIColor = .purple
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = layer.bounds.width / 2
        clipsToBounds = true
        backgroundColor = color
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
