//
//  Persistence.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "GitHubRepo")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
}
