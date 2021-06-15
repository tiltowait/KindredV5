//
//  KindredListView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct KindredListView: View {
  
  static let tag = "Kindred"
  
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
          NavigationLink(destination: KindredView(kindred: cainite, dataController: dataController)) {
            KindredRowView(kindred: cainite)
          }
        }
        .onDelete(perform: delete)
      }
      .navigationTitle("Kindred")
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

struct KindredListView_Previews: PreviewProvider {
  static var previews: some View {
    KindredListView()
  }
}
