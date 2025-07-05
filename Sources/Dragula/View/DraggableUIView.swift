//
//  DraggableUIView.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//

#if canImport(UIKit)
import UIKit

final class DraggableUIView: UIView {
    // MARK: - Properties
    var dragPreviewCornerRadius: CGFloat = .zero
    private let previewView: UIView
    private let dropIndicatorView: UIView
    private let itemProvider: () -> NSItemProvider
    private let onDragWillBegin: (() -> Void)?
    private let onDragWillEnd: (() -> Void)?
    
    /// Initializes a draggable view with a preview and drop indicator.
    /// - Parameters:
    ///   - preview: The view displayed during dragging.
    ///   - dropView: The view used as a drop indicator.
    ///   - itemProvider: Closure that provides the `NSItemProvider` for drag items.
    ///   - onDragWillBegin: Optional closure called when dragging begins.
    ///   - onDragWillEnd: Optional closure called when dragging ends.
    init(
        preview: UIView,
        dropView: UIView,
        itemProvider: @escaping () -> NSItemProvider,
        onDragWillBegin: (() -> Void)? = nil,
        onDragWillEnd: (() -> Void)? = nil
    ) {
        self.previewView = preview
        self.dropIndicatorView = dropView
        self.itemProvider = itemProvider
        self.onDragWillBegin = onDragWillBegin
        self.onDragWillEnd = onDragWillEnd
        
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    /// Configures the view hierarchy and enables drag interaction.
    private func setupViews() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        let dragInteraction = UIDragInteraction(delegate: self)
        previewView.addInteraction(dragInteraction)

        addSubview(previewView)
        addSubview(dropIndicatorView)
        dropIndicatorView.alpha = .zero
    }

    /// Sets up Auto Layout constraints for the preview and drop indicator views.
    private func setupConstraints() {
        previewView.translatesAutoresizingMaskIntoConstraints = false
        dropIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: bottomAnchor),

            dropIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dropIndicatorView.topAnchor.constraint(equalTo: topAnchor),
            dropIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dropIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

 // MARK: - UIDragInteractionDelegate
extension DraggableUIView: UIDragInteractionDelegate {
    /// Provides the items to begin a drag session.
    /// Calls `onDragWillBegin` and returns a drag item from the `itemProvider`.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        itemsForBeginning session: UIDragSession
    ) -> [UIDragItem] {
        onDragWillBegin?()
        let item = UIDragItem(itemProvider: itemProvider())
        return [item]
    }

    /// Provides additional items when adding to an existing drag session.
    /// Calls `onDragWillBegin` and returns a drag item from the `itemProvider`.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        itemsForAddingTo session: any UIDragSession,
        withTouchAt point: CGPoint
    ) -> [UIDragItem] {
        onDragWillBegin?()
        return [UIDragItem(itemProvider: itemProvider())]
    }

    /// Returns a custom preview for the lifted drag item.
    /// Creates a rounded snapshot of the source view.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        previewForLifting item: UIDragItem,
        session: UIDragSession
    ) -> UITargetedDragPreview? {
        guard let sourceView = interaction.view else { return nil }
        let imageView = UIImageView(image: sourceView.snapshot())
        imageView.bounds = sourceView.bounds

        let parameters = UIDragPreviewParameters()
        parameters.visiblePath = UIBezierPath(
            roundedRect: imageView.bounds,
            cornerRadius: dragPreviewCornerRadius
        )
        let target = UIDragPreviewTarget(
            container: sourceView.superview!,
            center: sourceView.center
        )
        return UITargetedDragPreview(
            view: imageView,
            parameters: parameters,
            target: target
        )
    }

    /// Animates the lift of the drag, fading out the preview and showing the drop indicator.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        willAnimateLiftWith animator: any UIDragAnimating,
        session: any UIDragSession
    ) {
        dropIndicatorView.isHidden = false
        animator.addAnimations { [weak self] in
            self?.previewView.alpha = .zero
            self?.dropIndicatorView.alpha = 1
        }
        animator.addCompletion { [weak self] _ in
            self?.previewView.isHidden = true
        }
    }

    /// Returns the preview to use if the drag is cancelled.
    /// Positions it back at the source view's center.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        previewForCancelling item: UIDragItem,
        withDefault defaultPreview: UITargetedDragPreview
    ) -> UITargetedDragPreview? {
        guard let view = interaction.view,
              let superview = view.superview else {
            return defaultPreview
        }
        let target = UIDragPreviewTarget(container: superview, center: view.center)
        return UITargetedDragPreview(
            view: defaultPreview.view,
            parameters: UIDragPreviewParameters(),
            target: target
        )
    }

    /// Indicates whether to use full-size previews for the drag session. Returns `true`.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        prefersFullSizePreviewsFor session: any UIDragSession
    ) -> Bool {
        true
    }

    /// Animates the cancellation of a drag, restoring the preview and hiding the drop indicator.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        item: UIDragItem,
        willAnimateCancelWith animator: UIDragAnimating
    ) {
        animator.addAnimations { [weak self] in
            self?.dropIndicatorView.alpha = .zero
            self?.previewView.alpha = 1
        }
        animator.addCompletion { [weak self] _ in
            self?.previewView.isHidden = false
            self?.dropIndicatorView.isHidden = true
        }
    }

    /// Called when the drag session is about to end. Triggers `onDragWillEnd`.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        session: UIDragSession,
        willEndWith operation: UIDropOperation
    ) {
        onDragWillEnd?()
    }

    /// Restricts dragging to this application only. Returns `true`.
    func dragInteraction(
        _ interaction: UIDragInteraction,
        sessionIsRestrictedToDraggingApplication session: any UIDragSession
    ) -> Bool {
        true
    }
}

#endif
