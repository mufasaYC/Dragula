//
//  DragulaSectionDropDelegate.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//  Contributed to Dragula
//

#if !os(watchOS)
import SwiftUI

struct DragulaSectionDropDelegate<Section: DragulaSection>: DropDelegate {
    
    private let generator = UIImpactFeedbackGenerator(style: .rigid)
    
    private let item: Section.Item? // when nil it means dropping into a section
    private let sectionID: Section.ID
    @Binding private var sections: [Section]
    @Binding private var draggedItems: [Section.Item]
        
    private let animation: Animation = .spring

    init(
        item: Section.Item?,
        sectionID: Section.ID,
        sections: Binding<[Section]>,
        draggedItems: Binding<[Section.Item]>
    ) {
        self.item = item
        self.sectionID = sectionID
        self._sections = sections
        self._draggedItems = draggedItems
    }

    func performDrop(info: DropInfo) -> Bool {
        !draggedItems.isEmpty
    }
    
    private func sectionIndex(for item: Section.Item) -> Int? {
        sections.firstIndex(where: { section in
            section.items.contains { $0.id == item.id }
        })
    }
    
    private func itemIndex(for item: Section.Item) -> Int? {
        for section in sections {
            if let index = section.items.firstIndex(where: { $0.id == item.id }) {
                return index
            }
        }
        return nil
    }
    
    func dropEntered(info: DropInfo) {
        guard !draggedItems.isEmpty else {
            return
        }

        // Prevent inserting on top of any dragged item
        guard draggedItems.allSatisfy({ $0.id != item?.id }) else {
            return
        }

        let toSectionIndex: Int
        if let item, let index = sectionIndex(for: item) {
            toSectionIndex = index
        } else if let index = sections.firstIndex(where: { $0.id == sectionID }) {
            toSectionIndex = index
        } else {
            return
        }
        
        var didPerformAnyChanges: Bool = false

        withAnimation(animation) {
            // Remove dragged items from their original sections
            for draggedItem in draggedItems {
                if let fromSectionIndex = sectionIndex(for: draggedItem),
                   let fromIndex = itemIndex(for: draggedItem) {
                    let toIndex: Int
                    if let item, let index = itemIndex(for: item) {
                        toIndex = index
                    } else {
                        toIndex = .zero
                    }
                    
                    if fromSectionIndex == toSectionIndex {
                        if fromIndex != toIndex {
                            didPerformAnyChanges = true
                            sections[toSectionIndex].items.move(
                                fromOffsets: IndexSet(integer: fromIndex),
                                toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex
                            )
                        }
                    } else {
                        didPerformAnyChanges = true
                        // Insert dragged items starting at calculated drop index
                        sections[fromSectionIndex].items.remove(at: fromIndex)
                        sections[toSectionIndex].items.insert(draggedItem, at: toIndex)
                    }
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
    
    func validateDrop(info: DropInfo) -> Bool {
        if item == nil {
            // user is dropping it to a section in this case as item wasn't supplied
            // check if item is in same section, if so, do nothing
            let sectionIndices = Set(draggedItems.compactMap { sectionIndex(for: $0) })
            if sectionIndices.count == 1,
               let sectionIndex = sectionIndices.first,
               sections[sectionIndex].id == sectionID {
                return false
            } else {
                return true
            }
        }
        
        return true
    }
}
#endif
