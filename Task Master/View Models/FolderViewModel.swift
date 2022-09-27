//
//  FolderViewModel.swift
//  Task Master
//
//  Created by Tim Bausch on 9/26/22.
//

import CoreData
import Foundation
import UIKit

final class FolderViewModel {
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    var folders: [Folder] = []
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        folders = getFolders() ?? []
    }
    
    public func getFolders() -> [Folder]? {
        let folderFetch: NSFetchRequest<Folder> = Folder.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(folderFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }
    
    public func addFolder(name: String, image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let newFolder = Folder(context: managedObjectContext)
        newFolder.name = name
        newFolder.image = imageData
        
        coreDataStack.saveContext(managedObjectContext)
    }
    
    public func deleteFolder(_ folder: Folder) {
        managedObjectContext.delete(folder)
        coreDataStack.saveContext(managedObjectContext)
    }
    
}
