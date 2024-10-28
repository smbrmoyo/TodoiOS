//
//  TodoView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodoView: View {
    let todo: Todo
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.3))
            
            HStack {
                Image("Vector")
                    .padding()
                                
                VStack(alignment: .leading) {
                    Text(todo.taskDescription)
                        .fontWeight(.medium)
                    
                    Text("Due: \(todo.dueDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                    
                    Text("Created: \(todo.createdDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Image("Check-box")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Image("delete")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 100)
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
    }
}

#Preview {
    TodosListView()
}
