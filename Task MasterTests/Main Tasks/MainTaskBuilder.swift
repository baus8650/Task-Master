//
//  MainTaskBuilder.swift
//  Task MasterTests
//
//  Created by Tim Bausch on 9/27/22.
//

import Foundation
import Task_Master
import UIKit

final class MainTaskBuilder {
    private var name = "Test Main Task"
    private var isCompleted = false
    private var dateCreated = Date()
    private var dateDue = Date()
    private var id = UUID()
    
    func name(_ name: String) -> Self {
        self.name = name
        return self
    }
    
    func isCompleted(_ isCompleted: Bool) -> Self {
        self.isCompleted = isCompleted
        return self
    }
    
    func dateCreated(_ dateCreated: Date) -> Self {
        self.dateCreated = dateCreated
        return self
    }
    
    func dateDue(_ dateDue: Date) -> Self {
        self.dateDue = dateDue
        return self
    }
    
    func id(_ id: UUID) -> Self {
        self.id = id
        return self
    }
    
    func build() -> TestFolder {
        return TestMainTask(name: name, isCompleted: isCompleted, dateCreated: dateCreated, dateDue: dateDue, id: id)
    }
}

struct TestMainTask {
    var name: String
    var isCompleted: Bool
    var dateCreated: Date
    var dateDue: Date
    var id: UUID
}

