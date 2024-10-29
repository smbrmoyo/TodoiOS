//
//  CustomDatePicker.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct CustomDatePicker: View {
    @Binding var date: Date
    
    var body: some View {
        HStack {
            DatePicker("",
                       selection: $date,
                       displayedComponents: .date)
            .datePickerStyle(.compact)
            .labelsHidden()
            .background(Color(.systemGray4))
            
            Spacer()
            
            Image(systemName: "calendar")
                .imageScale(.large)
        }
    }
}

#Preview {
    CustomDatePicker(date: .constant(.now))
}
