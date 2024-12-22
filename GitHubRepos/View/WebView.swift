//
//  WebView.swift
//  GitHubRepos
//
//  Created by RISHIN JOSHI on 23/12/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onAuthSuccess: ((String) -> Void)?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onAuthSuccess: onAuthSuccess)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var onAuthSuccess: ((String) -> Void)?

        init(onAuthSuccess: ((String) -> Void)?) {
            self.onAuthSuccess = onAuthSuccess
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url,
               url.absoluteString.starts(with: "myapp://callback"),
               let queryItems = URLComponents(string: url.absoluteString)?.queryItems,
               let code = queryItems.first(where: { $0.name == "code" })?.value {
                onAuthSuccess?(code)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
    }
}
