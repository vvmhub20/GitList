//
//  SearchBar.swift
//  GitHubRepos
//
//  Created by Vandana's MacbookAir on 20/12/24.
//

import Foundation
import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onTextChanged: (() -> Void)? // Callback when the text changes

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onTextChanged: onTextChanged)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        var onTextChanged: (() -> Void)?

        init(text: Binding<String>, onTextChanged: (() -> Void)?) {
            _text = text
            self.onTextChanged = onTextChanged
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
            onTextChanged?()
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            text = searchBar.text ?? ""
        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            onTextChanged?()
            searchBar.resignFirstResponder()
        }
    }
}

