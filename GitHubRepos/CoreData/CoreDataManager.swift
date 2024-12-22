//
//  CoreDataManager.swift
//  GitHubRepos
//
//  Created by RISHIN JOSHI on 23/12/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext

    private init() {
        self.context = PersistenceController.shared.container.viewContext
    }

    /// Saves a list of repositories to Core Data.
    /// - Parameter repositories: An array of `Repository` objects to save.
    func saveRepositories(_ repositories: [Repository]) {
        context.perform {
            repositories.forEach { repo in
                let entity = RepositoryEntity(context: self.context)
                entity.id = Int32(repo.id)
                entity.name = repo.name
                entity.repoDescription = repo.description
                entity.stars = Int32(repo.stars)
                entity.forks = Int32(repo.forks)
                entity.lastUpdated = repo.lastUpdated
            }
            do {
                try self.context.save()
            } catch {
                print("Error saving repositories to Core Data: \(error)")
            }
        }
    }

    /// Fetches all repositories from Core Data.
    /// - Returns: An array of `Repository` objects.
    func fetchRepositories() -> [Repository] {
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities.map { entity in
                Repository(
                    id: Int(entity.id),
                    name: entity.name ?? "",
                    description: entity.repoDescription,
                    stars: Int(entity.stars),
                    forks: Int(entity.forks),
                    lastUpdated: entity.lastUpdated ?? Date()
                )
            }
        } catch {
            print("Error fetching repositories from Core Data: \(error)")
            return []
        }
    }

    /// Deletes all repositories from Core Data.
    func deleteAllRepositories() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RepositoryEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error deleting all repositories from Core Data: \(error)")
        }
    }
}
