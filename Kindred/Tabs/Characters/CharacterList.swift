//
//  CharacterList.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct CharacterList: View {
  
  @EnvironmentObject var dataController: DataController
  @FetchRequest(
    entity: Kindred.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Kindred.zName, ascending: true)]
  ) var kindred: FetchedResults<Kindred>
  
  @State private var showingCreationSheet = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(kindred) { cainite in
          NavigationLink(destination: KindredDetail(kindred: cainite, dataController: dataController)) {
            KindredRow(kindred: cainite)
          }
        }
        .onDelete(perform: delete)
      }
      .navigationTitle("Characters")
      .toolbar {
        Button {
          showingCreationSheet.toggle()
        } label: {
          Label("Add Kindred", systemImage: "plus")
        }
      }
    }
    .sheet(isPresented: $showingCreationSheet) {
      AddKindredView()
    }
  }
  
  func delete(_ offsets: IndexSet) {
    for offset in offsets {
      let cainite = kindred[offset]
      dataController.delete(cainite)
    }
    dataController.save()
  }
}

struct CharacterList_Previews: PreviewProvider {
  static var previews: some View {
    CharacterList()
      .environmentObject(DataController.preview)
      .environment(\.managedObjectContext, DataController.preview.container.viewContext)
  }
}
