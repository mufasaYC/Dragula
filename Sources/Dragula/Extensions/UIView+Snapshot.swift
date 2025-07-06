//
//  UIView+Snapshot.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//

#if !os(watchOS) && canImport(UIKit)
import UIKit

extension UIView {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

#endif
