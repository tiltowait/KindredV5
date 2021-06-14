//
//  KindredListView.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/13/21.
//

import SwiftUI

struct KindredListView: View {
  
  static let tag = "Kindred"
  
  @FetchRequest(
    entity: Kindred.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Kindred.zName, ascending: true)]
  ) var kindred: FetchedResults<Kindred>
  
  @State private var showingCreationSheet = false
  
  var body: some View {
    NavigationView {
      List(kindred) { cainite in
        Text(cainite.name)
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
}

struct KindredListView_Previews: PreviewProvider {
  static var previews: some View {
    KindredListView()
  }
}
