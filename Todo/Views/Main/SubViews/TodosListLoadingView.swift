//
//  TodosListLoadingView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct TodosListLoadingView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0..<10) { _ in
                    TodoLoadingView()
                }
            }
        }
    }
}

#Preview {
    TodosListLoadingView()
}
