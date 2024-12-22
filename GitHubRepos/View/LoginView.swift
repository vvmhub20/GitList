//
//  LoginView.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showWebView = false
    @State private var isLoading = false // For showing the loading indicator
    
    var body: some View {
        VStack {
            Text("GitHub Repositories App")
                .font(.largeTitle)
                .padding()

            Button("Login with GitHub") {
                isLoading = true
                showWebView = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .fullScreenCover(isPresented: $showWebView) {
            VStack {
                if isLoading {
                    VStack {
                        ProgressView("Opening Web View...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8))
                }
                if let authURL = authViewModel.authURL {
                    WebView(url: authURL) { code in
                        isLoading = false
                        showWebView = false
                        authViewModel.exchangeCodeForAccessToken(code: code)
                    }
                }
            }
        }
    }
}
