//
//  RepositoryRow.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import SwiftUI

// MARK: - RepositoryRow
struct RepositoryRow: View {
    let repository: Repository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.name)
                .font(.headline)
            Text(repository.description ?? "No description")
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("⭐️ \(repository.stars)")
                Text("🍴 \(repository.forks)")
                Spacer()
                Text("Updated: \(repository.lastUpdated, formatter: DateFormatter.shortDate)")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
    }
}
