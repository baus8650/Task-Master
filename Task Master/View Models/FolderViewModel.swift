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
    
    @Published var imageList: [String] = []
    
    @Published var colorList: [String] = []
    
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        setUpLists()
        self.folders = getFolders() ?? []
    }
    
    private func setUpLists() {
        colorList = [
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
        
        imageList = [
            "scribble",
            "pencil",
            "folder.fill",
            "paperplane.fill",
            "tray.fill",
            "doc.fill",
            "doc.plaintext.fill",
            "terminal.fill",
            "books.vertical.fill",
            "book.closed.fill",
            "magazine.fill",
            "bookmark.fill",
            "graduationcap.fill",
            "paperclip",
            "person.fill",
            "person.2.fill",
            "person.3.fill",
            "photo.artframe",
            "moon.fill",
            "globe.americas.fill",
            "globe.europe.africa.fill",
            "globe.asia.australia.fill",
            "zzz",
            "record.circle",
            "megaphone.fill",
            "music.quarternote.3",
            "swift",
            "loupe",
            "mic.fill",
            "heart.fill",
            "flag.fill",
            "location.fill",
            "tag.fill",
            "tshirt.fill",
            "eyes.inverse",
            "flashlight.on.fill",
            "camera.fill",
            "message.fill",
            "phone.fill",
            "envelope.fill",
            "metronome.fill",
            "paintbrush.fill",
            "wrench.and.screwdriver.fill",
            "stethoscope",
            "briefcase.fill",
            "house.fill",
            "building.2.fill",
            "pin.fill",
            "map.fill",
            "gift.fill",
            "tv",
            "airplane",
            "guitars.fill",
            "car.fill",
            "bicycle",
            "pills.fill",
            "cross.fill",
            "pawprint.fill",
            "leaf.fill",
            "photo.fill.on.rectangle.fill",
            "shield.fill",
            "cup.and.saucer.fill",
            "fork.knife",
            "hourglass",
            "list.bullet",
            "questionmark"
        ]
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
    
    public func addFolder(name: String, imageString: String, colorHexValue: String) {
        let newFolder = Folder(context: managedObjectContext)
        newFolder.id = UUID()
        newFolder.name = name
        newFolder.imageString = imageString
        newFolder.colorHex = colorHexValue
        
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
    
    public func addDummyFolderWithTasks() {
        let newFolder = Folder(context: managedObjectContext)
        newFolder.id = UUID()
        newFolder.name = "Test Folder"
        newFolder.imageString = "list.bullet"
        newFolder.colorHex = "9420A5"
        
        let newTask1 = MainTask(context: managedObjectContext)
        newTask1.id = UUID()
        newTask1.name = "Test Subtask 1"
        newTask1.dateCreated = Date()
        newTask1.dateDue = Date()
        newTask1.isCompleted = false
        newTask1.isShowingSubtasks = false
        
        let newTask2 = MainTask(context: managedObjectContext)
        newTask2.id = UUID()
        newTask2.name = "Test Subtask 2"
        newTask2.dateCreated = Date()
        newTask2.dateDue = Date()
        newTask2.isCompleted = false
        newTask2.isShowingSubtasks = false
        
        newFolder.tasks = [newTask1, newTask2]
        
        coreDataStack.saveContext(managedObjectContext)
        folders = getFolders() ?? []
    }
    
}
