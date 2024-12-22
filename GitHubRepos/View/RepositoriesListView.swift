//
//  RepositoriesListView.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import SwiftUI

struct RepositoriesListView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(
                    text: $viewModel.searchQuery,
                    placeholder: "Search Repositories",
                    onTextChanged: {
                        viewModel.filterRepositories(by: viewModel.searchQuery)
                    }
                )
                List {
                    ForEach(viewModel.repositories) { repo in
                        RepositoryRow(repository: repo)
                    }
                    // Only show "Load More" button if there's more data to load
                    if viewModel.hasMoreData && !viewModel.isFetching {
                        Button(action: {
                            viewModel.fetchRepositories(accessToken: authViewModel.accessToken ?? "", isPaginated: true)
                        }) {
                            Text("Load More")
                                .foregroundColor(.blue)
                                .padding()
                        }
                    } else if viewModel.isLoading {
                        // Optionally, show a loading indicator while fetching
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Repositories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleLogout) {
                        Text("Logout")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                if let token = authViewModel.accessToken {
                    viewModel.fetchRepositories(accessToken: token)
                } else {
                    viewModel.repositories = CoreDataManager.shared.fetchRepositories()
                    viewModel.allRepositories = CoreDataManager.shared.fetchRepositories()
                }
            }
            .onChange(of: viewModel.searchQuery) { newQuery in
                viewModel.filterRepositories(by: newQuery)
            }
        }
    }

    private func handleLogout() {
        authViewModel.isAuthenticated = false
        authViewModel.accessToken = nil
        viewModel.repositories.removeAll()
        CoreDataManager.shared.deleteAllRepositories()
    }
}

