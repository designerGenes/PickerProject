//
//  PickerView.swift
//  PickerProject
//
//  Created by Jaden Nation on 5/24/24.
//

import SwiftUI
import Combine

// the row's view model
class PickerRowViewModel: ObservableObject, Hashable, Identifiable {
    static func == (lhs: PickerRowViewModel, rhs: PickerRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(title)
            hasher.combine(subtitle)
    }
    
    weak var pickerViewModel: PickerViewModel?
    var id = UUID()
    var title: String?
    var subtitle: String?
    @Published var isSelected: Bool
    
    init(title: String? = nil, subtitle: String? = nil, isSelected: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.isSelected = isSelected
    }
}

// the row view
struct PickerViewRow: View {
    @ObservedObject var data: PickerRowViewModel
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 12) {
                Text(data.title ?? "")
                Text(data.subtitle ?? "")
            }
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(data.isSelected ? .black : .clear)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            data.isSelected.toggle()
        }
    }
}

// the screen's view model
class PickerViewModel: ObservableObject, Hashable, Identifiable {
    static var defaultRows: [PickerRowViewModel] = [
        .init(title: "Wishbone", subtitle: "a Dog's Life"),
        .init(title: "Ghostwriter", subtitle: "a saucy Ghost"),
        .init(title: "Captain Planet", subtitle: "by our powers combined!"),
        .init(title: "Between The Lions", subtitle: "banned in your country"),
    ]
    
    
    
    @Published var pickerRows: [PickerRowViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    var id = UUID()
    
    private func setupSubscriptions() {
        pickerRows.forEach { row in
            row.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &cancellables)
        }
    }
    
    init(pickerRows: [PickerRowViewModel]? = []) {
        self.pickerRows = pickerRows ?? []
        setupSubscriptions()
    }
    
    static func == (lhs: PickerViewModel, rhs: PickerViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
}

// the screen
struct PickerView: View {
    @ObservedObject var viewModel: PickerViewModel
    var body: some View {
        List {
            Section("1990s") {
                Text("Selected: \(viewModel.pickerRows.filter({$0.isSelected}).count)")
                ForEach(viewModel.pickerRows) { pickerRowData in
                    PickerViewRow(data: pickerRowData)
                }
            }
        }
        .navigationTitle("TV Shows")
    }
}


// The previews
#Preview {
    let rowsData = PickerViewModel.defaultRows
    let viewModel = PickerViewModel(pickerRows: rowsData)
    return NavigationStack {
        PickerView(viewModel: viewModel)
    }
}

#Preview("PickerViewRow") {
    PickerViewRow(data: PickerRowViewModel(title: "Title", subtitle: "Subtitle"))
}
