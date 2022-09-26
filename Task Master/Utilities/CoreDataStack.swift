//
//  PersistenceController.swift
//  Task Master
//
//  Created by Tim Bausch on 9/26/22.
//

import CoreData
import Foundation
import UIKit

open class CoreDataStack {
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    
    private init() {
        self.container = NSPersistentContainer(name: "Task_Master")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data \(error)")
            }
        }
    }
}
