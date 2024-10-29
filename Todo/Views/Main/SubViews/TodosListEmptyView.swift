//
//  TodosListEmptyView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct TodosListEmptyView: View {
    var body: some View {
        VStack {
            Text("No Todos Found.")
                .foregroundStyle(.gray)
                .font(.largeTitle)
        }
    }
}

#Preview {
    TodosListEmptyView()
}
