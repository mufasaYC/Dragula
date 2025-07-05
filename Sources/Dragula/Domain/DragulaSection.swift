//
//  DragulaSection.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 05/06/25.
//  Refactored by Eugene Kovs on 04.07.2025.
//

import Foundation

/// A protocol representing a section that contains drag-and-droppable items.
/// Conforming types must provide an array of `DragulaItem`-conforming items.
///
/// - Example:
/// ```swift
/// struct TaskSection: DragulaSection {
///     let id: UUID
///     let title: String
///     var items: [TaskItem]
/// }
/// ```
public protocol DragulaSection: Identifiable {
    /// The type of item contained in the section.
    associatedtype Item: DragulaItem
    /// The items contained in this section.
    var items: [Item] { get set }
}
