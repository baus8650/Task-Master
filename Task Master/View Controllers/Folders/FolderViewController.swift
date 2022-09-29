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
    
    var dataSource: UICollectionViewDiffableDataSource<Section, FolderHierarchy>!
    
    enum Section {
        case main
    }
    
    enum FolderHierarchy: Hashable {
        case folder(Folder)
        case task(MainTask)
    }
    
    
    // MARK: - Views
    
    private lazy var addButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        return barButton
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = compositionalLayout()
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.backgroundColor = UIColor(named: "Background")
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.backgroundColor = UIColor(named: "Background")
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(FolderCollectionViewCell.self, forCellWithReuseIdentifier: "folderCell")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.title = "Folders"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.coreDataStack = CoreDataStack()
        self.viewModel = FolderViewModel(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        
        dataSource = makeDataSource()
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
            self.updateDataSource()
        }
        .store(in: &subscriptions)
    }
    
    private func updateDataSource() {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<FolderHierarchy>()
        
        for folder in folderList{
            let header = FolderHierarchy.folder(folder)
            sectionSnapshot.append([header])
            let allTasks = folder.tasks?.allObjects as? [MainTask]
            if allTasks?.count ?? 0 > 0 {
                for task in allTasks! {
                    sectionSnapshot.append([FolderHierarchy.task(task)], to: header)
                }
            }
        }
        
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: true, completion: nil)
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, FolderHierarchy> {
        let folderRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Folder> { cell, indexPath, item in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            content.image = UIImage(systemName: item.imageString ?? "list.bullet")!.withTintColor(UIColor(hex: item.colorHex!)!, renderingMode: .alwaysOriginal)
            cell.contentConfiguration = content
            if item.tasks?.count ?? 0 > 0 {
                let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header)
                cell.accessories = [
                    .delete(displayed: .whenEditing, actionHandler: {
                        self.viewModel.deleteFolder(item)
                    }),
                    .outlineDisclosure(options:headerDisclosureOption)
                ]
            } else {
                cell.accessories = [
                    .delete(displayed: .whenEditing, actionHandler: {
                        self.viewModel.deleteFolder(item)
                    })
                ]
            }
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MainTask> { cell, indexPath, item in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.indentationLevel = 2
            cell.contentConfiguration = content
        }
        
        return UICollectionViewDiffableDataSource<Section, FolderHierarchy>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                
                switch item{
                case .folder(let folderItem):
                    /* LEAVING THIS HERE IN CASE I CHANGE MY MIND
                     
                     let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "folderCell", for: indexPath) as! FolderCollectionViewCell
                     cell.folderName.text = folderItem.name
                     let image = UIImage(systemName: folderItem.imageString ?? "list.bullet")
                     cell.folderImage.image = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
                     cell.folderImageBackground.backgroundColor = UIColor(hex: folderItem.colorHex ?? "9C80B5")
                     cell.deleteButton.tag = indexPath.row
                     cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), for: .touchUpInside)
                     if folderItem.tasks?.count != 0 {
                     cell.hasSubTasks = true
                     } else {
                     cell.hasSubTasks = false
                     }
                     
                     */
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: folderRegistration,
                        for: indexPath,
                        item: folderItem)
                    
                    return cell
                    
                case .task(let taskItem):
                    
                    let cell = collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration,
                        for: indexPath,
                        item: taskItem)
                    
                    return cell
                }
            })
    }
    
    @objc
    private func addButtonTapped() {
        let addFolderVC = AddFolderViewController(viewModel: viewModel)
        present(addFolderVC, animated: true)
    }
    
    private func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/9))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc
    private func deleteButtonTapped(_ sender: UIButton) {
        let ac = UIAlertController(title: "Delete Folder", message: "Are you sure you want to delete this folder? Deleting this folder will also delete all associated tasks. This action cannot be undone.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteFolder(self.folderList[sender.tag])
        }))
        present(ac, animated: true)
    }
    
}

extension FolderViewController: UICollectionViewDelegate {
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        
        if editing {
            collectionView.isEditing = true
        } else {
            collectionView.isEditing = false
        }
        
        self.collectionView.reloadData()
        
    }
}

