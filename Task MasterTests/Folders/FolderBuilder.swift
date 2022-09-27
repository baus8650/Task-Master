//
//  FolderBuilder.swift
//  Task MasterTests
//
//  Created by Tim Bausch on 9/26/22.
//

import Foundation
import Task_Master
import UIKit

final class FolderBuilder {
    private var name = "Test Folder"
    private var image = UIImage(systemName: "list.bullet")
    private var mainTasks: [TestMainTask] = [MainTaskBuilder().build()]
    
    func name(_ name: String) -> Self {
        self.name = name
        return self
    }
    
    func image(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
    
    func mainTask(_ mainTasks: TestMainTask) -> Self {
        self.maintasks = mainTasks
    }
    
    func build() -> TestFolder {
        return TestFolder(name: name, image: image, mainTasks: mainTasks)
    }
}

struct TestFolder {
    var name: String
    var image: UIImage?
    var mainTasks: [TestMainTask]
}
