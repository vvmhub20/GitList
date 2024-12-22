//
//  Repository.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import CoreData

// MARK: - Repository Model
struct Repository: Identifiable, Decodable {
    let id: Int
    let name: String
    let description: String?
    let stars: Int
    let forks: Int
    let lastUpdated: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case stars = "stargazers_count" // Map to the correct JSON key
        case forks
        case lastUpdated = "updated_at" // Assuming this is the key for the last updated date
    }
}

// MARK: - Core Data Conversion
extension Repository {
    init(from entity: RepositoryEntity) {
        self.id = Int(entity.id)
        self.name = entity.name ?? "Unknown"
        self.description = entity.repoDescription
        self.stars = Int(entity.stars)
        self.forks = Int(entity.forks)
        self.lastUpdated = entity.lastUpdated ?? Date()
    }

    func toEntity(context: NSManagedObjectContext) -> RepositoryEntity {
        let entity = RepositoryEntity(context: context)
        entity.id = Int32(self.id)
        entity.name = self.name
        entity.repoDescription = self.description
        entity.stars = Int32(self.stars)
        entity.forks = Int32(self.forks)
        entity.lastUpdated = self.lastUpdated
        return entity
    }
}

