//
//  DropView.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//  Refactored by Eugene Kovs on 05.07.2025.
//

import SwiftUI

struct DropView: View {
    
    let item: Section.Item
    
    var body: some View {
        Rectangle()
            .fill(item.color.opacity(0.2))
            .clipShape(.rect(cornerRadius: 16))
            .padding(.horizontal)
    }
    
}
