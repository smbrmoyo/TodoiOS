//
//  RadioButton.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct RadioButton: View {
    @Binding private var isSelected: Bool
    private let label: String
    
    init<V: Hashable>(tag: V, selection: Binding<V>, label: String = "") {
        self._isSelected = Binding(
            get: { selection.wrappedValue == tag },
            set: { _ in selection.wrappedValue = tag }
        )
        self.label = label
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(isSelected ? Color.black : Color.clear)
                .padding(4)
                .overlay(
                    Circle()
                        .stroke(.black, lineWidth: 1)
                )
                .frame(width: 20, height: 20)
            
            Text(label)
        }
        .onTapGesture { isSelected = true }
    }
}

#Preview {
    RadioButton(tag: QueryFilter.all,
                selection: .constant(QueryFilter.all),
                label: QueryFilter.all.rawValue.capitalized)
}
