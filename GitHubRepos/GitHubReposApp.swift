//
//  GitHubReposApp.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import SwiftUI

@main
struct GitHubReposApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            // The `.onOpenURL` modifier captures the URL scheme
            if authViewModel.isAuthenticated {
                RepositoriesListView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
//                    .onOpenURL { url in
//                        // Handle the custom URL scheme (myapp://callback?code=...)
//                        if url.scheme == "myapp" && url.host == "callback" {
//                            // Extract the code from the URL query parameters
//                            if let code = url.queryParameters?["code"] {
//                                // Notify the AuthViewModel to handle the code
//                                NotificationCenter.default.post(name: .didReceiveGitHubCode, object: code)
//                                
//                            }
//                        }
//                    }
            }
        }
    }
}

