//
//  RepositoriesViewModel.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation

class RepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false // For initial loading
    @Published var isPaginating: Bool = false // For pagination loading
    @Published var searchQuery: String = ""
    
    var allRepositories: [Repository] = []
    private var currentPage: Int = 1
    private let itemsPerPage: Int = 5
    var isFetching: Bool = false
    var hasMoreData: Bool = true

    let repositoryService: RepositoryService

    init(repositoryService: RepositoryService = RepositoryService()) {
        self.repositoryService = repositoryService
    }

    func fetchRepositories(accessToken: String, isPaginated: Bool = false) {
        // Check if already fetching or there's no more data
        guard !isFetching, hasMoreData else { return }

        // Set appropriate loading state
        if isPaginated {
            isPaginating = true
        } else {
            isLoading = true
        }

        isFetching = true

        repositoryService.fetchRepositories(accessToken: accessToken, page: currentPage, itemsPerPage: itemsPerPage) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                // Reset loading states
                self.isFetching = false
                self.isLoading = false
                self.isPaginating = false

                switch result {
                case .success(let repos):
                    if repos.isEmpty {
                        self.hasMoreData = false
                    } else {
                        if isPaginated {
                            self.repositories.append(contentsOf: repos)
                        } else {
                            self.repositories = repos
                        }
                        self.allRepositories.append(contentsOf: repos)
                        CoreDataManager.shared.saveRepositories(self.allRepositories)
                        self.currentPage += 1
                    }
                case .failure(let error):
                    print("Error fetching repositories: \(error)")
                }
            }
        }
    }

    func filterRepositories(by query: String) {
        if query.isEmpty {
            repositories = allRepositories
        } else {
            repositories = allRepositories.filter { repo in
                repo.name.localizedCaseInsensitiveContains(query)
            }
        }
    }
}

