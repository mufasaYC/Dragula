//
//  SectionView.swift
//  Dragula
//
//  Created by Mustafa Yusuf on 06/06/25.
//  Refactored by Eugene Kovs on 05.07.2025.
//

import SwiftUI

struct SectionView: View {
    
    let section: Section
    
    var body: some View {
        Text(section.title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.vertical, 8)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
