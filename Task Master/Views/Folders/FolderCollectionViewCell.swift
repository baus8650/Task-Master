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
    
    var disclosureButtonIsExpanded: Bool = false
    var hasSubTasks: Bool = false
    
    lazy var folderName: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    lazy var folderImage: UIImageView = {
        let imageView = UIImageView(forAutoLayout: ())
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.autoSetDimensions(to: CGSize(width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var folderImageBackground: UIView = {
        let view = UIView(forAutoLayout: ())
        view.autoSetDimensions(to: CGSize(width: 28, height: 28))
        view.layer.cornerRadius = 14
        
        view.addSubview(folderImage)
        folderImage.autoCenterInSuperviewMargins()
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.autoSetDimensions(to: CGSize(width: 16, height: 16))
        button.setImage(UIImage(systemName: "x.circle.fill")!.withTintColor(UIColor(red: 1.0, green: 0.43, blue: 0.39, alpha: 1.0), renderingMode: .alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var chevronDisclosure: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(rotateButton), for: .touchUpInside)
        return button
    }()
    
    lazy var contentStack: UIStackView = {
        let stackView = UIStackView(forAutoLayout: ())
        stackView.autoSetDimension(.height, toSize: 28)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.addArrangedSubview(folderImageBackground)
        stackView.addArrangedSubview(folderName)
        stackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(chevronDisclosure)
        if hasSubTasks {
            chevronDisclosure.isHidden = false
        } else {
            chevronDisclosure.isHidden = true
        }
        return stackView
    }()
    
    @objc
    private func rotateButton() {
        disclosureButtonIsExpanded.toggle()
        if disclosureButtonIsExpanded {
            UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) {
                self.chevronDisclosure.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
            }
        } else {
            UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5) {
                self.chevronDisclosure.transform = CGAffineTransform.identity
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 6
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
