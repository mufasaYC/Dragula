//
//  DragPreviewCornerRadiusKey.swift
//  Dragula
//
//  Created by Eugene Kovs on 04.07.2025.
//  https://github.com/kovs705
//  Contributed to Dragula
//

import SwiftUI

/// An environment key to customize the corner radius of the drag preview.
private struct DragPreviewCornerRadiusKey: EnvironmentKey {
    static let defaultValue: CGFloat = 12
}

/// A SwiftUI environment value that controls the corner radius of draggable preview content.
/// You can set this value on any view using `.environment(\.dragPreviewCornerRadius, radius)`
extension EnvironmentValues {
    /// The corner radius applied to drag preview content.
    public var dragPreviewCornerRadius: CGFloat {
        get { self[DragPreviewCornerRadiusKey.self] }
        set { self[DragPreviewCornerRadiusKey.self] = newValue }
    }
}
