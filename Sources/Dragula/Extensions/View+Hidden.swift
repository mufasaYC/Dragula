//
//  View+Hidden.swift
//  Dragula
//
//  Created by Eugene Kovs on 04.07.2025.
//  https://github.com/kovs705
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
