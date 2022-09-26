//
//  TestCoreDataStack.swift
//  Task MasterTests
//
//  Created by Tim Bausch on 9/26/22.
//

import CoreData
import XCTest

final class TestCoreDataStack {
    static let shared = TestCoreDataStack()
    let container: NSPersistentContainer
    
    private init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        self.container = NSPersistentContainer(name: "Task_Master")
        self.container.persistentStoreDescriptions = [persistentStoreDescription]
        self.container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data \(error)")
            }
        }
    }
}
