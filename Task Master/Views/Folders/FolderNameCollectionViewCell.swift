//
//  FolderNameCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import PureLayout
import UIKit

class FolderNameCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var name: String!
    
    // MARK: - Views
    private lazy var nameField: UITextField = {
        let textField = UITextField(forAutoLayout: ())
//        textField.autoSetDimension(.height, toSize: 48)
        textField.placeholder = "Folder Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        addSubview(nameField)
        nameField.autoPinEdgesToSuperviewMargins()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
