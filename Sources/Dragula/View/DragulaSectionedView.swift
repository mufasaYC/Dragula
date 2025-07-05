//
//  DragulaSectionedView.swift
//  Dragula
//
//  Created by Mustafa Yusuf
//  Refactored by Eugene Kovs on 04.07.2025.
//

import SwiftUI
import UniformTypeIdentifiers

/// A reusable SwiftUI view that supports sectioned drag-and-drop reordering of items.
///
/// Each section has a header and a list of draggable items represented by `Card`.
///
/// - Parameters:
///   - Header: A view shown as the section header.
///   - Card: A draggable item view.
///   - DropView: A view to display during drag-over state.
///   - Section: The section type conforming to `DragulaSection`.
///
/// - Example:
/// ```swift
/// DragulaSectionedView(sections: $sections) { section in
///     Text(section.title)
/// } card: { item in
///     Text(item.title)
/// } dropView: { item in
///     Color.gray
/// } dropCompleted: {
///     print("Drop completed")
/// }
/// ```
public struct DragulaSectionedView<Header: View,
                                         Card: View,
                                         DropView: View,
                                         Section: DragulaSection>: View {
    
    @Binding private var sections: [Section]
    @Binding private var items: [Section.Item]
    @State private var draggedItems: [Section.Item] = []
    
    private let header: (Section) -> Header
    private let card: (Section.Item) -> Card
    private let dropView: ((Section.Item) -> DropView)?
    private let dropCompleted: () -> Void
    
    private let supportedUTTypes: [UTType] = []
    
    /// Creates a sectioned drag-and-drop view.
    /// - Parameters:
    ///   - sections: A binding to an array of sections.
    ///   - header: View builder for each section header.
    ///   - card: View builder for each item.
    ///   - dropView: View builder for the drop-over indicator.
    ///   - dropCompleted: Called when a drop completes.
    public init(
        sections: Binding<[Section]>,
        @ViewBuilder header: @escaping (Section) -> Header,
        @ViewBuilder card: @escaping (Section.Item) -> Card,
        @ViewBuilder dropView: @escaping (Section.Item) -> DropView,
        dropCompleted: @escaping () -> Void
    ) {
        self._sections = sections
        self._items = .constant([])
        self.header = header
        self.card = card
        self.dropView = dropView
        self.dropCompleted = dropCompleted
    }
    
    public init(
        items: Binding<[Section.Item]>,
        @ViewBuilder header: @escaping (Section) -> Header,
        @ViewBuilder card: @escaping (Section.Item) -> Card,
        @ViewBuilder dropView: @escaping (Section.Item) -> DropView,
        dropCompleted: @escaping () -> Void
    ) {
        self._sections = .constant([])
        self._items = items
        self.header = header
        self.card = card
        self.dropView = dropView
        self.dropCompleted = dropCompleted
    }
    
    public var body: some View {
        ForEach(sections) { section in
            #if os(watchOS)
            header(section)
            #else
            header(section)
                .onDrop(
                    of: supportedUTTypes,
                    delegate: DragulaSectionDropDelegate(
                        item: nil,
                        sectionID: section.id,
                        sections: $sections,
                        draggedItems: $draggedItems
                    )
                )
            #endif
            
            ForEach(section.items) { item in
                #if os(watchOS)
                card(item)
                #else
                card(item)
                    .hidden(item.isDraggable)
                    .overlay {
                        if item.isDraggable {
                            DraggableView(
                                preview: {
                                    card(item)
                                }, dropView: {
                                    dropView?(item)
                                }, itemProvider: {
                                    item.getItemProvider()
                                }, onDragWillBegin: {
                                    self.draggedItems.append(item)
                                }, onDragWillEnd: {
                                    self.draggedItems = []
                                    self.dropCompleted()
                                })
                        }
                    }
                    .onDrop(
                        of: supportedUTTypes,
                        delegate: DragulaSectionDropDelegate(
                            item: item,
                            sectionID: section.id,
                            sections: $sections,
                            draggedItems: $draggedItems
                        )
                    )
                #endif
            }
        }
    }
}
