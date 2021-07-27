//
//  RitualList.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/27/21.
//

import SwiftUI
import CoreData

struct RitualList: View {
  
  let title: String
  let rituals: [Int: [Ritual]]
  
  init(flavor: Ritual.Flavor, dataController: DataController) {
    let request: NSFetchRequest<Ritual> = Ritual.fetchRequest()
    request.predicate = NSPredicate(format: "discipline.zName == %@", flavor.disciplineName)
    request.sortDescriptors = [
      NSSortDescriptor(keyPath: \Ritual.level, ascending: true),
      NSSortDescriptor(keyPath: \Ritual.zName, ascending: true)
    ]
    
    let allRituals = dataController.fetch(request: request)
    var groupedRituals: [Int: [Ritual]] = [:]
    
    // Rituals range from level 1 to level 5
    for level in 1...5 {
      let filtered = allRituals.filter { $0.level == level }
      groupedRituals[level] = filtered
    }
    
    self.title = flavor == .ritual ? "Blood Sorcery Rituals" : "Oblivion Ceremonies"
    self.rituals = groupedRituals
  }
  
  var body: some View {
    List {
      ForEach(1...5) { level in
        Section(header: Text("Level \(level)")) {
          ForEach(rituals[level]!) { ritual in
            RitualRow(ritual: ritual)
          }
        }
      }
    }
    .navigationBarTitle(title, displayMode: .inline)
    .listStyle(InsetGroupedListStyle())
  }
}

struct RitualList_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      RitualList(flavor: .ritual, dataController: DataController.preview)
    }
  }
}
