//
//  Created by Mustafa Yusuf on 05/06/25.
//

import SwiftUI
import UIKit

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

/// A protocol for individual drag-and-droppable items.
/// Conforming types can provide an `NSItemProvider` for drag interaction.
///
/// - Example:
/// ```swift
/// struct TaskItem: DragulaItem {
///     let id: UUID
///     let title: String
///
///     func getItemProvider() -> NSItemProvider {
///         NSItemProvider(object: title as NSString)
///     }
/// }
public protocol DragulaItem: Identifiable {
    /// Override to make an item not draggable, default value is `true`
    var isDraggable: Bool { get }
    /// Override to provide a meaningful item provider for drag sessions.
    func getItemProvider() -> NSItemProvider
}

extension DragulaItem {
    /// Default implementation marks a DragulaItem as draggable
    public var isDraggable: Bool { true }
    
    /// Default implementation returns an empty item provider.
    public func getItemProvider() -> NSItemProvider {
        .init()
    }
}
