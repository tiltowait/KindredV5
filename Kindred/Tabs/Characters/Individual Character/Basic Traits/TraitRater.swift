//
//  TraitRater.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/15/21.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct TraitRater: View {
  
  @EnvironmentObject var dataController: DataController
  
  @ObservedObject var kindred: Kindred
  let keyPath: ReferenceWritableKeyPath<Kindred, Int16>
  let max: Int16
  let reference: String
  
  let showingSpecialties: Bool
  @State private var specialties: String?
  @State private var specialtyManager: SpecialtyManager?
  
  @State private var binding: Int16
  @State private var showingReferenceAlert = false
  
  let label: String
  let size: CGFloat = 17
  let spacing: CGFloat = 5

  init(
    kindred: Kindred,
    keyPath: ReferenceWritableKeyPath<Kindred, Int16>,
    max: Int16,
    type: Global.TraitType,
    reference: String
  ) {
    self.kindred = kindred
    self.keyPath = keyPath
    self.max = max
    self.reference = reference
    
    _binding = State(wrappedValue: kindred[keyPath: keyPath])
    label = keyPath.stringValue.unCamelCased.capitalized
    
    // Specialties
    showingSpecialties = type == .skills
    let specialties = kindred.specialties(for: label)?.joined(separator: ", ")
    _specialties = State(wrappedValue: specialties)
  }
  
  var addSpecialtyButton: some View {
    Group {
      if showingSpecialties {
        Button(action: createSpecialtyManager) {
          Label("Add specialty", systemImage: "circle.grid.2x2")
            .labelStyle(IconOnlyLabelStyle())
        }
        .buttonStyle(BorderlessButtonStyle())
      }
    }
  }
  
  var specialtiesLabel: some View {
    Group {
      if let specialties = specialties {
        BoldLabel("Specialties:", details: specialties)
          .font(.caption)
      }
    }
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        addSpecialtyButton
        
        Text("\(label):")
          .bold()
        
        Spacer()
        
        DotSelector(
          current: $binding.onChange(updateTrait),
          min: 0,
          max: max
        )
        
        // Reference button
        Button {
          showingReferenceAlert.toggle()
        } label: {
          Label("Reference", systemImage: "info.circle")
            .labelStyle(IconOnlyLabelStyle())
        }
        .buttonStyle(BorderlessButtonStyle())
      }
      specialtiesLabel
    }
    .sheet(item: $specialtyManager) { manager in
      manager
    }
    .alert(isPresented: $showingReferenceAlert) {
      Alert(title: Text(label), message: Text(reference), dismissButton: .default(Text("OK")))
    }
//    .onDisappear(perform: updateTrait)
  }
  
  /// Create a specialty manager for display.
  func createSpecialtyManager() {
    specialtyManager = SpecialtyManager(
      skill: label,
      kindred: kindred,
      dataController: dataController,
      binding: $specialties
    )
  }
  
  /// Update the character's trait with the value of the binding.
  func updateTrait(to newValue: Int16) {
    kindred[keyPath: keyPath] = newValue
  }
  
}

#if DEBUG
struct TraitRater_Previews: PreviewProvider {
  static var previews: some View {
    TraitRater(kindred: Kindred.example, keyPath: \.occult, max: 5, type: .skills, reference: "Test reference")
      .previewLayout(.sizeThatFits)
  }
}
#endif
