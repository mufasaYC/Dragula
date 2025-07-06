//
//  DraggableView.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//

#if !os(watchOS)
import SwiftUI
import UIKit

/// A SwiftUI-compatible wrapper for a `UIView` that supports UIDragInteraction.
///
/// Allows injecting drag preview and drop views with drag lifecycle callbacks.
///
/// - Parameters:
///   - Preview: The view used as the visual representation during drag.
///   - DropView: The view displayed when the item is being dragged.
///   - itemProvider: Provides the data for the drag session.
///   - onDragWillBegin: Called when a drag is about to begin.
///   - onDragWillEnd: Called when the drag session ends.
struct DraggableView<Preview: View, DropView: View>: UIViewRepresentable {
    
    @Environment(\.dragPreviewCornerRadius) private var dragPreviewCornerRadius
    
    private let itemProvider: () -> NSItemProvider
    private let onDragWillBegin: (() -> Void)?
    private let onDragWillEnd: (() -> Void)?
    private let preview: () -> Preview
    private let dropView: () -> DropView

    /// Initializes a draggable view.
    /// - Parameters:
    ///   - preview: The drag preview view.
    ///   - dropView: The drop indicator view.
    ///   - itemProvider: Closure to provide the drag item.
    ///   - onDragWillBegin: Called before drag starts.
    ///   - onDragWillEnd: Called when drag ends.
    init(
        @ViewBuilder preview: @escaping () -> Preview,
        @ViewBuilder dropView: @escaping () -> DropView,
        itemProvider: @escaping () -> NSItemProvider,
        onDragWillBegin: (() -> Void)?,
        onDragWillEnd: (() -> Void)?
    ) {
        self.preview = preview
        self.dropView = dropView
        self.itemProvider = itemProvider
        self.onDragWillBegin = onDragWillBegin
        self.onDragWillEnd = onDragWillEnd
    }

    func makeUIView(context: Context) -> DraggableUIView {
        let uiPreview = UIHostingController(rootView: preview()).view!
        uiPreview.backgroundColor = .clear
        let uiDropView = UIHostingController(rootView: dropView()).view!
        uiDropView.backgroundColor = .clear

        let draggableView = DraggableUIView(
            preview: uiPreview,
            dropView: uiDropView,
            itemProvider: itemProvider,
            onDragWillBegin: onDragWillBegin,
            onDragWillEnd: onDragWillEnd
        )
        draggableView.dragPreviewCornerRadius = dragPreviewCornerRadius
        return draggableView
    }

    func updateUIView(_ uiView: DraggableUIView, context: Context) {
        uiView.dragPreviewCornerRadius = dragPreviewCornerRadius
    }
}
#endif
