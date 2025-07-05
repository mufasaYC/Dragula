//
//  Section.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//  Contributed to Dragula
//

import SwiftUI

struct Section: DragulaSection {
    
    struct Item: DragulaItem {
        let id: UUID = .init()
        let title: String
        let color: Color
        var isDraggable: Bool = true
    }
    
    let id: UUID = .init()
    let title: String
    var items: [Item] = []
}
