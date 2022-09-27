//
//  FolderCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/26/22.
//

import Foundation
import PureLayout
import UIKit

class FolderCollectionViewCell: UICollectionViewCell {
    
    lazy var folderName: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    lazy var folderImage: UIImageView = {
        let imageView = UIImageView(forAutoLayout: ())
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.autoSetDimensions(to: CGSize(width: 24, height: 24))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var contentStack: UIStackView = {
        let stackView = UIStackView(forAutoLayout: ())
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.addArrangedSubview(folderImage)
        stackView.addArrangedSubview(folderName)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "CellBackground")
        layer.cornerRadius = 6
        layer.borderWidth = 1
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        addViews()
    }
    
    func addViews(){
        addSubview(contentStack)
        contentStack.autoPinEdgesToSuperviewMargins()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
