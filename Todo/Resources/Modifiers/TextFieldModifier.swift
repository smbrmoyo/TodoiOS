//
//  TextFieldModifier.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            
            content
                .lineLimit(3)
                .frame(height: 44)
                .padding(.vertical, 4)
                .padding(.horizontal)
                .textInputAutocapitalization(.sentences)
                .multilineTextAlignment(.leading)
                .background(Color(.systemGray4))
                .cornerRadius(10)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
                .font(.system(size: 17, weight: .regular))
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    TextField("", text: .constant(""))
        .customTextField(title: "To-Do Item Name")
}
