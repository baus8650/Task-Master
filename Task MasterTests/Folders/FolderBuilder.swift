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
    
    func name(_ name: String) -> Self {
        self.name = name
        return self
    }
    
    func image(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
    
    func build() -> TestFolder {
        return TestFolder(name: name, image: image)
    }
}

struct TestFolder {
    var name: String
    var image: UIImage?
}
