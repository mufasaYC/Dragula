//
//  Created by Mustafa Yusuf on 05/06/25.
//

import SwiftUI
import UIKit



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
