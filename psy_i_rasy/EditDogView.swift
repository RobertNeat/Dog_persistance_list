//
//  EditDogView.swift
//  psy_i_rasy
//
//  Created by apple on 05/06/2023.
//

import SwiftUI

struct EditDogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var dog: Dog

    @State private var editName: String
    @State private var editYear: String

    @Environment(\.presentationMode) var presentationMode

    init(dog: Dog) {
        self.dog = dog
        _editName = State(initialValue: dog.name ?? "")
        _editYear = State(initialValue: String(dog.yearBirth))
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Podaj nowe imię", text: $editName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Podaj nowy rok urodzenia", text: $editYear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    saveDogChanges()
                }) {
                    Text("Edytuj")
                }
            }
            .navigationTitle("Edytuj psa")
        }
        .onAppear {
            editName = dog.name ?? ""
            editYear = String(dog.yearBirth)
        }
    }

    private func saveDogChanges() {
        dog.name = editName
        dog.yearBirth = Int16(editYear) ?? 0

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}



//
//struct EditDogView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dog = Dog()
//
//        return EditDogView(dog: dog)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
