//
//  AddFOlderViewController.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import PureLayout
import UIKit

class AddFolderViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var viewTitle: String = "Add Folder"
    
    // MARK: - Views
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setTitle("  Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(forAutoLayout: ())
        label.text = "Add Folder"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(forAutoLayout: ())
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(saveButton)
        stack.autoSetDimension(.height, toSize: 24)
        return stack
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = compositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
        collectionView.dataSource = self
        collectionView.register(FolderColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.register(FolderImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.register(FolderNameCollectionViewCell.self, forCellWithReuseIdentifier: "nameCell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        
        setUpSubviews()
    }
    
    // MARK: - Helper Functions
    
    private func setUpSubviews() {
        view.addSubview(titleStack)
        view.addSubview(collectionView)
        titleStack.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        titleStack.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        titleStack.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        collectionView.autoPinEdge(.top, to: .bottom, of: titleStack, withOffset: 8)
        collectionView.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    }
    
    func compositionalLayout() -> UICollectionViewCompositionalLayout {
        //1
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/6))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 6)
        
        let titleGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/10))
        let titleGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: titleGroupSize,
            subitem: item,
            count: 1)
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let section = NSCollectionLayoutSection(group: titleGroup)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 4,
                    leading: 4,
                    bottom: 4,
                    trailing: 4)
                return section
            } else {
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 20,
                    leading: 4,
                    bottom: 4,
                    trailing: 4)
                section.interGroupSpacing = 4
                return section
            }
            
        }
        
//        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }

}

extension AddFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 12
        case 2:
            return 72
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nameCell", for: indexPath) as! FolderNameCollectionViewCell
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! FolderColorCollectionViewCell
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FolderImageCollectionViewCell
            cell.imageView.image = UIImage(systemName: "list.bullet")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! FolderColorCollectionViewCell
            return cell
        }
    }
    
    
}
