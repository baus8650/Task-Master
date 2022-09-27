//
//  ViewController.swift
//  Task Master
//
//  Created by Tim Bausch on 9/26/22.
//

import Combine
import PureLayout
import UIKit

class FolderViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: FolderViewModel!
    private var coreDataStack: CoreDataStack!
    private var subscriptions = Set<AnyCancellable>()
    private var folderList: [Folder] = []
    
    // MARK: - Views
    
    private lazy var addButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return barButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = compositionalLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = view.backgroundColor
//        collectionView.refreshControl = refreshControl
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "folderCell")
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.coreDataStack = CoreDataStack()
        self.viewModel = FolderViewModel(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        
        setUpSubviews()
        setupBindings()
    }

    // MARK: - Helper Functions
    
    private func setUpSubviews() {
        view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewMargins()
    }
    
    private func setupBindings() {
        viewModel.$folders.sink { folders in
            self.folderList = folders
            self.collectionView.reloadData()
        }
        .store(in: &subscriptions)
    }
    
    @objc
    private func addButtonTapped() {
        viewModel.addFolder(name: "Pets", image: UIImage(systemName: "pawprint.fill")!)
        viewModel.addFolder(name: "Home", image: UIImage(systemName: "house.fill")!)
        viewModel.addFolder(name: "Medicine", image: UIImage(systemName: "pills.fill")!)
        viewModel.addFolder(name: "Games", image: UIImage(systemName: "logo.playstation")!)
    }
    
    private func compositionalLayout() -> UICollectionViewLayout {
        let insets: CGFloat = 12
        var itemCount: Int
        var itemSizeWidthDimension: NSCollectionLayoutDimension
        var itemSize: NSCollectionLayoutSize
        var groupSize: NSCollectionLayoutSize
        let topSpace: CGFloat
        
        
        itemCount = 1
        itemSizeWidthDimension = .fractionalWidth(1)
        itemSize = NSCollectionLayoutSize(
            widthDimension: itemSizeWidthDimension,
            heightDimension: .absolute(52))
        groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(96))
        topSpace = .zero
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: itemCount)
        group.interItemSpacing = .fixed(insets)
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: topSpace,
                leading: insets,
                bottom: 0,
                trailing: insets)
            section.interGroupSpacing = insets
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    @objc
    private func deleteButtonTapped(_ sender: UIButton) {
        viewModel.deleteFolder(folderList[sender.tag])
    }

}

extension FolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        folderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
        cell.folderName.text = folderList[indexPath.row].name
        let image = UIImage(data: folderList[indexPath.row].image!)
        cell.folderImage.image = image
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        return cell
    }
}

extension FolderViewController: UICollectionViewDelegate {
    
}

