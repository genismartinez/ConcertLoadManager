import SwiftUI

struct AddItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""

    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                TextField("Enter name", text: $name)
            }
            
            Button(action: addItem) {
                Text("Add Item")
            }
        }
        .navigationTitle("Add New Item")
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = name
            newItem.isPacked = false

            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
