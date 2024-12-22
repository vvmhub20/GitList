//
//  RepositoryService.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import CoreData

// MARK: - RepositoryService
class RepositoryService {
    private let context = PersistenceController.shared.container.viewContext

    func fetchRepositories(accessToken: String, page: Int, itemsPerPage: Int, completion: @escaping (Result<[Repository], Error>) -> Void) {
        
        //let urlString = "https://api.github.com/user/repos?per_page=100" //uncomment this line to check real user data

        
        let urlString = "https://api.github.com/users/octocat/repos?per_page=\(itemsPerPage)&page=\(page)" //dummy data
        print(urlString)
       
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        //uncomment above line to check real user

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                let repositories = try jsonDecoder.decode([Repository].self, from: data)

               // self.saveRepositoriesToCoreData(repositories: repositories)
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
