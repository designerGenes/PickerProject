//
//  ContentView.swift
//  PickerProject
//
//  Created by Jaden Nation on 5/24/24.
//

import SwiftUI

struct NavigatingRow: View {
    var body: some View {
        HStack {
            Text("Go to row")
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Navigation") {
                    NavigationLink(value: PickerViewModel(pickerRows: PickerViewModel.defaultRows)) {
                        Text("Navigate!")
                    }
                    
                }
            }
            .navigationDestination(for: PickerViewModel.self) { pickerViewModel in
                PickerView(viewModel: pickerViewModel)
            }
        }
        
    }
}

#Preview {
    ContentView()
}
