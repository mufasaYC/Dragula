//
//  DragulaView.swift
//  Dragula
//
//  Created by Mustafa Yusuf
//  Refactored by Eugene Kovs on 04.07.2025.
//  Contributed to Dragula
//

import SwiftUI
import UniformTypeIdentifiers

/// A reusable SwiftUI view that supports drag-and-drop reordering of a flat list of items.
///
/// - Parameters:
///   - Card: The draggable item view.
///   - DropView: A view to show during a drag-over state.
///   - Item: The item type conforming to `DragulaItem`.
///
/// - Example:
/// ```swift
/// DragulaView(items: $tasks) { item in
///     Text(item.title)
/// } dropView: { item in
///     Color.secondary
/// } dropCompleted: {
///     print("Items reordered")
/// }
/// ```
public struct DragulaView<Card: View, DropView: View, Item: DragulaItem>: View {
    
    @State private var draggedItems: [Item] = []
    
    @Binding var items: [Item]
    private let card: (Item) -> Card
    private let dropView: ((Item) -> DropView)?
    private let dropCompleted: () -> Void
    
    private let supportedUTTypes: [UTType] = []
    
    /// Creates a drag-and-drop view for a flat list of items.
    /// - Parameters:
    ///   - items: A binding to an array of items.
    ///   - card: View builder for each item.
    ///   - dropView: View builder for the drop-over indicator.
    ///   - dropCompleted: Called when a drop completes.
    public init(
        items: Binding<[Item]>,
        @ViewBuilder card: @escaping (Item) -> Card,
        @ViewBuilder dropView: @escaping (Item) -> DropView,
        dropCompleted: @escaping () -> Void
    ) {
        self._items = items
        self.card = card
        self.dropView = dropView
        self.dropCompleted = dropCompleted
    }
    
    public var body: some View {
        ForEach(items) { item in
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
                    delegate: DragulaDropDelegate(
                        item: item,
                        items: $items,
                        draggedItems: $draggedItems
                    )
                )
                #endif
        }
    }
}

