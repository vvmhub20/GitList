//
//  AuthViewModel.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import UIKit


// AuthViewModel.swift
// GitHubRepos
//
// Created by Vandana's MacbookAir on 20/12/24.

import Foundation
import UIKit

// MARK: - AuthViewModel
class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var accessToken: String? = nil
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    // MARK: - Private Properties
    private let authService = AuthService()

    // MARK: - Initializer
    init() {
        // Load the initial state from UserDefaults
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
    }
    
    // MARK: - Computed Properties
    var authURL: URL? {
        let clientId = "Ov23lihDVO1Jw0FhoLzi"
        let redirectUri = "myapp://callback"
        let state = UUID().uuidString // Random state for security
        let scope = "repo user"
        let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&scope=\(scope)&state=\(state)"
        return URL(string: urlString)
    }
    
    // MARK: - Methods
    func exchangeCodeForAccessToken(code: String) {
        authService.exchangeCodeForAccessToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    self?.accessToken = token
                    self?.isAuthenticated = true
                }
            case .failure(let error):
                print("Failed to exchange code for access token: \(error.localizedDescription)")
            }
        }
    }
    
    func logout() {
        accessToken = nil
        isAuthenticated = false
    }
}

//
//// MARK: - AuthViewModel
//class AuthViewModel: ObservableObject {
//
//    // MARK: - Published Properties
//    @Published var accessToken: String? = nil
//
//    @Published var isAuthenticated: Bool {
//            didSet {
//                UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
//            }
//        }
//
//    
//    // MARK: - Private Properties
//    private let clientId = "Ov23lihDVO1Jw0FhoLzi"
//    private let clientSecret = "64824d1ec887a73b90b445f672a9dbf4ed3915d5"
//    private let redirectUri = "myapp://callback"
//    let state = UUID().uuidString // Random state for security
//    let scope = "repo user"
//    
//    // MARK: - Computed Properties
//    var authURL: URL? {
//            let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&scope=\(scope)&state=\(state)"
//            return URL(string: urlString)
//        }
//    
//   
//    // MARK: - Initializer
//
//    init() {
//        // Load the initial state from UserDefaults
//        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
//    }
//
//
//
//    func exchangeCodeForAccessToken(code: String) {
//        print("Authorization code received: \(code)")
//        
//        let tokenUrl = "https://github.com/login/oauth/access_token"
//        guard let url = URL(string: tokenUrl) else {
//            print("Invalid token URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        let body: [String: String] = [
//            "client_id": clientId,
//            "client_secret": clientSecret,
//            "code": code,
//            "redirect_uri": redirectUri
//        ]
//        
//        // Convert body dictionary to URL-encoded string
//        let bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
//        request.httpBody = bodyString.data(using: .utf8)
//
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("Error exchanging code for access token: \(error.localizedDescription)")
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("HTTP Status Code: \(httpResponse.statusCode)")
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            // Parse the response data
//            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let accessToken = json["access_token"] as? String {
//                print("Access Token: \(accessToken)")
//                DispatchQueue.main.async {
//                    self.accessToken = accessToken
//                    self.isAuthenticated = true
//                }
//            } else if let responseString = String(data: data, encoding: .utf8) {
//                print("Response: \(responseString)")
//            } else {
//                print("Failed to parse access token response")
//            }
//        }.resume()
//    }
//
//    func logout() {
//        accessToken = nil
//        isAuthenticated = false
//    }
//}
