//
//  ItemCard.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//  Refactored by Eugene Kovs on 05.07.2025.
//

import SwiftUI

struct ItemCard: View {
    
    let item: Section.Item
    
    var body: some View {
        HStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(item.color)
            Text(item.title)
        }
        .font(.body)
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
    
}
