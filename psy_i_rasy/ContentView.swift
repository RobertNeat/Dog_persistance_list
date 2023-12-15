//  ContentView.swift

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true//do zapewnienia że jednokrotnie rasy się dodadzą, a nie przy każdym uruchomieniu
    
    @State private var dogName = ""
    @State private var dogYearBirth = ""
    @State private var dogBreed = ""
    @State private var refresh: Bool = false

    //pobranie danych z encji
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dog.name, ascending: true)],
        animation: .default
    )
    private var dogs: FetchedResults<Dog>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Breed.name, ascending: true)],
        animation: .default
    )
    private var breeds: FetchedResults<Breed>

    
    
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("Nazwa psa", text: $dogName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                
                TextField("Wiek psa", text: $dogYearBirth)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(10)
                
                Text("Wybierz rasę")
                Picker("Opcje", selection: $dogBreed) {
                    ForEach(breeds, id: \.self) { breed in
                        Text(breed.name!).tag(breed.name!)
                    }
                }
                
                
                Button(action: {
                    // Add the action you want to perform when the button is tapped
                    print("Button tapped!")
                    
                    addDog()
                }) {
                    Text("Dodaj dane psa")
                }
                
                
                List {
                    ForEach(breeds) {breed in
                        Section(header: Text("\(breed.name!)")){
                            ForEach(breed.dogArray){ dog in
                                NavigationLink(destination: EditDogView(dog: dog)){//NavigationLink(destination: EditDogView(dog:dog)){
                                    Text("\(dog.name!) - urodzony w \(dog.yearBirth)")
                                }
                            }.onDelete(perform: deleteDog)
                        }
                    }
                }
                
                
            }.onAppear {//podczas ładowania dodać przykładowe rasy, żeby w pickerze były dostępne
                refreshController()
                if isFirstLaunch {
                    addBreed()
                    isFirstLaunch = false
                }
                
                
                
            }
        }
    }
    
     func refreshController() {
         
        viewContext.refreshAllObjects()
         
         do {
             
             try viewContext.save()
         } catch {
             let nsError = error as NSError
             fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
         }
     }


    
    private func addBreed(){
        var newBreed = Breed(context: viewContext)
        newBreed.name = "owczarek niemiecki"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError),\(nsError.userInfo)")
        }

        newBreed = Breed(context: viewContext)
        newBreed.name = "husky"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError),\(nsError.userInfo)")
        }
    }
    
    private func addDog() {
        if !dogName.isEmpty && !dogYearBirth.isEmpty {
            let newDog = Dog(context: viewContext)
            newDog.name = dogName

            if let birth = Int16(dogYearBirth) {
                newDog.yearBirth = birth
            } else {
                newDog.yearBirth = 0
            }

            if let selectedBreed = breeds.first(where: { $0.name == dogBreed }) {
                selectedBreed.addToToDog(newDog)
            }

            do {
                try viewContext.save()
                print("Dog added successfully.")
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


    private func deleteDog(offsets: IndexSet) {
        withAnimation {
            offsets.map { dogs[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError),\(nsError.userInfo)")
            }
        }
    }
    
    
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
