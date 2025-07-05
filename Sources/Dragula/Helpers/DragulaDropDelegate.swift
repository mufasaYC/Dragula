//
//  DragulaDropDelegate.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//  Contributed to Dragula
//

#if !os(watchOS)
import SwiftUI

struct DragulaDropDelegate<Item: DragulaItem>: DropDelegate {
    
    private let generator = UIImpactFeedbackGenerator(style: .rigid)
    
    private let item: Item
    @Binding private var items: [Item]
    @Binding private var draggedItems: [Item]
    
    private let animation: Animation = .spring
    
    init(
        item: Item,
        items: Binding<[Item]>,
        draggedItems: Binding<[Item]>
    ) {
        self.item = item
        self._items = items
        self._draggedItems = draggedItems
    }

    func performDrop(info: DropInfo) -> Bool {
        !draggedItems.isEmpty
    }
    
    private func index(of item: Item) -> Int? {
        items.firstIndex(where: { $0.id == item.id })
    }
    
    func dropEntered(info: DropInfo) {
        guard !draggedItems.isEmpty else {
            return
        }

        // Prevent inserting on top of any dragged item
        guard draggedItems.allSatisfy({ $0.id != item.id }) else {
            return
        }
        
        var didPerformAnyChanges: Bool = false
        
        withAnimation(animation) {
            // Remove dragged items from their original sections
            for dragged in draggedItems {
                if let fromIndex = index(of: dragged),
                   let toIndex = index(of: item) {
                    didPerformAnyChanges = true
                    items.move(
                        fromOffsets: IndexSet(integer: fromIndex),
                        toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                    )
                }
            }
        }
        
        if didPerformAnyChanges {
            playHaptic()
        }
    }
    
    func playHaptic() {
        generator.prepare()
        generator.impactOccurred()
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .cancel)
    }
}
#endif

