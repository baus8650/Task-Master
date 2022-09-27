//
//  Folder_TestCase.swift
//  Task MasterTests
//
//  Created by Tim Bausch on 9/26/22.
//

import CoreData
import XCTest
@testable import Task_Master

final class Folder_TestCase: XCTestCase {
    var folderViewModel: FolderViewModel!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        folderViewModel = FolderViewModel(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        super.tearDown()
        folderViewModel = nil
        coreDataStack = nil
    }

    func testAddFolder() throws {
        let newFolder = FolderBuilder().build()
        folderViewModel.addFolder(name: newFolder.name, image: newFolder.image!)
        let folders = folderViewModel.getFolders()
        XCTAssertEqual(folders?.count, 1)
        XCTAssertTrue(folders?.first?.name == "Test Folder")
        
    }
}
