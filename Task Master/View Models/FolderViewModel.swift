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
    var folders: [Folder] = []
    
    init() {
        getFolders()
    }
    
    public func getFolders() {
        let folderFetch: NSFetchRequest<Folder> = Folder.fetchRequest()
        do {
            let results = try CoreDataStack.shared.container.viewContext.fetch(folderFetch)
            self.folders = results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func addFolder(name: String, image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let newFolder = Folder(context: CoreDataStack.shared.container.viewContext)
        newFolder.name = name
        newFolder.image = imageData
        do {
            try CoreDataStack.shared.container.viewContext.save()
        } catch {
            print("Unable to save Folder \(error)")
        }
    }
    
    public func deleteFolder(_ folder: Folder) {
        CoreDataStack.shared.container.viewContext.delete(folder)
        do {
            try CoreDataStack.shared.container.viewContext.save()
        } catch {
            print("Unable to delete Folder \(error)")
        }
    }
    
}
