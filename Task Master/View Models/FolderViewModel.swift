//
//  FolderViewModel.swift
//  Task Master
//
//  Created by Tim Bausch on 9/26/22.
//

import CoreData
import Foundation
import Combine
import UIKit

final class FolderViewModel {
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    @Published var folders: [Folder] = []
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.folders = getFolders() ?? []
    }
    
    public func getFolders() -> [Folder]? {
        let folderFetch: NSFetchRequest<Folder> = Folder.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)
        folderFetch.sortDescriptors = [sort]
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
        newFolder.id = UUID()
        newFolder.name = name
        newFolder.image = imageData
        
        coreDataStack.saveContext(managedObjectContext)
        folders = getFolders() ?? []
    }
    
    public func deleteFolder(_ folder: Folder) {
        managedObjectContext.delete(folder)
        coreDataStack.saveContext(managedObjectContext)
        folders = getFolders() ?? []
    }
    
    public func addMainTask(name: String, dateDue: Date, isCompleted: Bool, to folder: Folder) {
        let folderFetch: NSFetchRequest<Folder> = Folder.fetchRequest()
        folderFetch.predicate = NSPredicate(format: "id == %@", folder.id! as CVarArg)
        do {
            let result = try managedObjectContext.fetch(folderFetch)
            let folder = result.first
            let newMainTask = MainTask(context: managedObjectContext)
            newMainTask.id = UUID()
            newMainTask.name = name
            newMainTask.dateCreated = Date()
            newMainTask.dateDue = dateDue
            newMainTask.isCompleted = isCompleted
            folder?.addToTasks(newMainTask)
            coreDataStack.saveContext(managedObjectContext)
        } catch {
            print("Could not find folder \(error)")
        }
    }
    
}
