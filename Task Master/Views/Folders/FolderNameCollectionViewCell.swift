//
//  FolderNameCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import Combine
import PureLayout
import UIKit

class FolderNameCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @Published var name: String!
    
    // MARK: - Views
    private lazy var nameField: UITextField = {
        let textField = UITextField(forAutoLayout: ())
        textField.delegate = self
        textField.placeholder = "Folder Name"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.borderStyle = .roundedRect
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

extension FolderNameCollectionViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var finalString = ""
        if range.length > 0 {
            finalString = "\(textField.text!.dropLast())"
        } else {
            finalString = "\(textField.text! + string)"
        }
        name = finalString
        return true
    }
}
