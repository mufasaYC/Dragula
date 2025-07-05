//
//  View+Hidden.swift
//  Dragula
//
//  Refactored by Eugene Kovs on 04.07.2025.
//  Contributed to Dragula
//

import SwiftUI

extension View {
    @ViewBuilder
    func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}
