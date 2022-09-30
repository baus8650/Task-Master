//
//  FolderImageCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import Combine
import PureLayout
import UIKit

class FolderImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(forAutoLayout: ())
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = layer.bounds.width / 2
        clipsToBounds = true
        backgroundColor = .lightGray
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        addSubview(imageView)
        imageView.autoPinEdgesToSuperviewMargins()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
