//
//  Utility.swift
//  GitHubRepos
//
//  Created by RISHIN JOSHI on 23/12/24.
//

import SwiftUI

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
