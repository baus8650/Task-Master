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
    private var image = "list.bullet"
    private var colorHexValue = "9c80b5"
    private var mainTasks: [TestMainTask] = [MainTaskBuilder().build()]
    
    func name(_ name: String) -> Self {
        self.name = name
        return self
    }
    
    func image(_ image: String) -> Self {
        self.image = image
        return self
    }
    
    func colorHexValue(_ colorHexValue: String) -> Self {
        self.colorHexValue = colorHexValue
        return self
    }
    
    func mainTask(_ mainTasks: [TestMainTask]) -> Self {
        self.mainTasks = mainTasks
        return self
    }
    
    func build() -> TestFolder {
        return TestFolder(name: name, image: image, colorHexValue: colorHexValue, mainTasks: mainTasks)
    }
}

struct TestFolder {
    var name: String
    var image: String
    var colorHexValue: String
    var mainTasks: [TestMainTask]
}
