//
//  SettingsViewModifier.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import SwiftUI

struct SettingsViewModifier: ViewModifier {
    @ObservedObject var todosListViewModel: TodosListViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.largeTitle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}
