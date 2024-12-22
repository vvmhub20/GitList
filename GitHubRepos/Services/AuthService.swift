//
//  AuthService.swift
//  GitHubRepos
//
//  Created by RISHIN JOSHI on 23/12/24.
//


import Foundation

// MARK: - AuthService
class AuthService {
    
    private let clientId = "Ov23lihDVO1Jw0FhoLzi"
    private let clientSecret = "64824d1ec887a73b90b445f672a9dbf4ed3915d5"
    private let redirectUri = "myapp://callback"
    
    func exchangeCodeForAccessToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("Authorization code received: \(code)")
        
        let tokenUrl = "https://github.com/login/oauth/access_token"
        guard let url = URL(string: tokenUrl) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "client_id": clientId,
            "client_secret": clientSecret,
            "code": code,
            "redirect_uri": redirectUri
        ]
        
        // Convert body dictionary to URL-encoded string
        let bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }

            // Parse the response data
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                print("Access Token: \(accessToken)")
                completion(.success(accessToken))
            } else if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                completion(.failure(NSError(domain: "Failed to parse access token response", code: 0, userInfo: nil)))
            }
        }.resume()
    }
}
