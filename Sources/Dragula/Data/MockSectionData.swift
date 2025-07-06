//
//  MockSectionData.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//  Refactored by Eugene Kovs on 04.07.2025.
//

import SwiftUI

/// Provides sample `Section` data for previews and testing.
enum MockSectionData {
    /// An array of sample sections with items.
    static let sections: [Section] = [
        Section(
            title: "Procrastination Tasks",
            items: [
                .init(title: "Stare at the wall meaningfully", color: .gray),
                .init(title: "Reorganize apps again", color: .blue),
                .init(title: "Clean desk to avoid real work", color: .mint),
                .init(title: "Not reorderable task", color: .orange, isDraggable: false)
            ]
        ),
        Section(
            title: "Midnight Epiphanies",
            items: [
                .init(title: "Invent app idea (never ship)", color: .purple),
                .init(title: "Learn guitar in 10 minutes", color: .orange)
            ]
        ),
        Section(
            title: "Important But Unnecessary",
            items: [
                .init(title: "Redesign onboarding for the 5th time", color: .pink),
                .init(title: "Buy domain name for joke startup", color: .teal)
            ]
        ),
        Section(
            title: "Developer Rituals",
            items: [
                .init(title: "Add TODO, ignore TODO", color: .indigo),
                .init(title: "Refactor perfectly good code", color: .red),
                .init(title: "Print debug(), feel powerful", color: .yellow)
            ]
        ),
        Section(
            title: "Existential Tasks",
            items: [
                .init(title: "Stare into the void (a.k.a. Xcode)", color: .mint),
                .init(title: "Wonder if UIKit was better", color: .cyan)
            ]
        )
    ]
}
