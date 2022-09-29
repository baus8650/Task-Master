//
//  AddFOlderViewController.swift
//  Task Master
//
//  Created by Tim Bausch on 9/27/22.
//

import Combine
import PureLayout
import UIKit

class AddFolderViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var viewTitle: String = "Add Folder"
    private var viewModel: FolderViewModel!
    
    private var folderName: String?
    private var folderColor: String?
    private var folderImage: String?
    
    private var imageList: [String]?
    private var colorList: [String]?
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Views
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(forAutoLayout: ())
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setTitle("  Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        collectionView.backgroundColor = UIColor(named: "Background")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FolderColorCollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
        collectionView.register(FolderImageCollectionViewCell.self, forCellWithReuseIdentifier: "imageCell")
        collectionView.register(FolderNameCollectionViewCell.self, forCellWithReuseIdentifier: "nameCell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        setUpSubviews()
        setUpBindings()
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
    
    private func setUpBindings() {
        viewModel.$imageList
            .sink { imageList in
                self.imageList = imageList
            }
            .store(in: &subscriptions)
        
        viewModel.$colorList
            .sink { colorList in
                self.colorList = colorList
            }
            .store(in: &subscriptions)
    }
    
    init(viewModel: FolderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc
    private func saveButtonTapped() {
        viewModel.addFolder(name: folderName ?? "", imageString: folderImage ?? "list.bullet", colorHexValue: folderColor ?? "9c80b5")
        dismiss(animated: true)
    }
    
    func compositionalLayout() -> UICollectionViewCompositionalLayout {
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
            return colorList?.count ?? 0
        case 2:
            return imageList?.count ?? 0
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
            cell.$name
                .sink { string in
                    self.folderName = string ?? ""
                }
                .store(in: &subscriptions)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! FolderColorCollectionViewCell
            cell.backgroundColor = UIColor(hex: colorList?[indexPath.row] ?? "F1F1F1")
            cell.colorSelectButton.tag = indexPath.row
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! FolderImageCollectionViewCell
            cell.imageView.image = UIImage(systemName: imageList?[indexPath.row] ?? "list.bullet")?.withTintColor(UIColor(hex: folderColor ?? "FFFFFF") ?? .white, renderingMode: .alwaysOriginal)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! FolderColorCollectionViewCell
            return cell
        }
    }
}

extension AddFolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("TAPPED CELL")
        switch indexPath.section {
        case 1:
            folderColor = colorList?[indexPath.row] ?? "F1F1F1"
            collectionView.reloadData()
        case 2:
            folderImage = imageList?[indexPath.row] ?? "list.bullet"
            print("TESTING \(folderImage)")
        default:
            print("Nothing to do")
        }
    }
}
