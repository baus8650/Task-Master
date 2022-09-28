//
//  FolderColorCollectionViewCell.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import PureLayout
import UIKit

class FolderColorCollectionViewCell: UICollectionViewCell {
    
    @Published var color: String = "9C80B5"
    
    lazy var colorSelectButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.addTarget(self, action: #selector(didSelectColor), for: .touchUpInside)
        return button
    }()
    
    let colorList: [String] = [
        "9C80B5",
        "8FF570",
        "FF6459",
        "FF9A60",
        "FFF07F",
        "6CFAFA",
        "7AB6FF",
        "C04AFF",
        "FD8FFF",
        "B8B8B8",
        "C99DB4",
        "FFD1F2"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = layer.bounds.width / 2
        clipsToBounds = true
        
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        addSubview(colorSelectButton)
        colorSelectButton.autoPinEdgesToSuperviewEdges()
    }
    
    @objc
    private func didSelectColor(_ sender: UIButton) {
        color = colorList[sender.tag]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
