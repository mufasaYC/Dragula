//
//  ContentView.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sections: [Section] = MockSectionData.sections
    
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
