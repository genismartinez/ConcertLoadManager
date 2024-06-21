import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var showingAddItemView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        HStack {
                            Toggle(isOn: Binding(
                                get: { item.isPacked },
                                set: { newValue in
                                    item.isPacked = newValue
                                    saveContext()
                                }
                            )) {
                                Text(item.name ?? "Unknown")
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("Carregat")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showingAddItemView = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: uncheckAllItems) {
                            Text("Desmarcar tot")
                                .foregroundColor(.red)
                        }
                    }
                }
                .sheet(isPresented: $showingAddItemView) {
                    AddItemView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }

    private func uncheckAllItems() {
        for item in items {
            item.isPacked = false
        }
        saveContext()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveContext()
        }
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
