//
//  ContentView.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sections: [Section] = [
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
    
    // MARK: - Body
    var body: some View {
        TabView {
            // sectioned vertical view
            sectionedVerticalView
            
            // non-sectioned vertical view
            nonSectionedVerticalView
            
            // horizontal sections with vertical scroll
            horizontalSections
        }
    }
    
    // MARK: - Components
    @ViewBuilder private var sectionedVerticalView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .zero) {
                DragulaSectionedView(sections: $sections) { section in
                    SectionView(section: section)
                } card: { item in
                    ItemCard(item: item)
                } dropView: { item in
                    DropView(item: item)
                } dropCompleted: {
                    // save the new order of sections and its items to the db
                }
                .environment(\.dragPreviewCornerRadius, 16)
            }
            .padding(.vertical)
        }
        .tabItem {
            Label("Vertical (Sections)", systemImage: "distribute.vertical.fill")
        }
    }
    
    @ViewBuilder private var nonSectionedVerticalView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: .zero) {
                DragulaView(items: $sections[0].items) { item in
                    ItemCard(item: item)
                } dropView: { item in
                    DropView(item: item)
                } dropCompleted: {
                    // save the new order of sections and its items to the db
                }
                .environment(\.dragPreviewCornerRadius, 16)
            }
            .padding(.vertical)
        }
        .tabItem {
            Label("Vertical (No Sections)", systemImage: "list.bullet.rectangle.fill")
        }
    }
    
    @ViewBuilder private var horizontalSections: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 24) {
                LazyVStack(alignment: .leading, spacing: .zero) {
                    ForEach($sections) { section in
                        SectionView(section: section.wrappedValue)
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 16) {
                                DragulaView(items: section.items) { item in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(item.color)
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 100)
                                } dropView: { item in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(item.color.opacity(0.2))
                                } dropCompleted: {
                                    // save the new order of sections and its items to the db
                                }
                                .environment(\.dragPreviewCornerRadius, 16)
                            }
                            .frame(height: 100)
                            .padding(.horizontal, 8)
                            .padding(.vertical)
                        }
                    }
                }
            }
        }
        .tabItem {
            Label("Horizontal (No Sections)", systemImage: "distribute.horizontal.fill")
        }
    }
    
}

#if DEBUG
#Preview {
    ContentView()
}
#endif
