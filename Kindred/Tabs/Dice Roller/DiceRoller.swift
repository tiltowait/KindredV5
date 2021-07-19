//
//  DiceRoller.swift
//  Kindred
//
//  Created by Jared Lindsay on 7/13/21.
//

import SwiftUI
import CoreHaptics

struct DiceRoller: View, Identifiable {
  
  var id = UUID()
  
  @StateObject var viewModel: ViewModel
  @State private var rolling = false
  
  @State private var engine = try? CHHapticEngine()
  
//  let bigFont = Font.system(size: 700, weight: .black, design: .monospaced)
//  let smallFont = Font.system(size: 200, design: .monospaced)
  let shouldRollOnAppear: Bool
  
  init(pool: Int? = 10, hunger: Int? = nil) {
    let viewModel = ViewModel()
    _viewModel = StateObject(wrappedValue: viewModel)
    
    if let pool = pool,
       let hunger = hunger {
      viewModel.pool = pool
      viewModel.hunger = hunger
      shouldRollOnAppear = true
    } else {
      shouldRollOnAppear = false
    }
  }
  
  var poolMenu: some View {
    MenuPicker(
      selected: $viewModel.pool,
      array: viewModel.poolRange
    ) { dice in
      diceLabel("pool", value: dice)
        .accentColor(.primary)
    }
  }
  
  var hungerMenu: some View {
    MenuPicker(
      selected: $viewModel.hunger,
      array: viewModel.hungerRange
    ) { hunger in
      diceLabel("hung", value: hunger)
        .accentColor(.red)
    }
  }
  
  var difficultyMenu: some View {
    MenuPicker(selected: $viewModel.difficulty, array: viewModel.difficultyRange) { difficulty in
      diceLabel("diff", value: difficulty)
        .accentColor(.vampireRed)
    }
  }
  
  var rollButton: some View {
    Button(action: roll) {
      HStack {
        Spacer()
        Label("Roll", systemImage: "diamond.fill")
          .font(.system(size: 30, weight: .black))
        Spacer()
      }
    }
    .buttonStyle(BoldButton(cornerRadius: 15, color: .red))
    .disabled(rolling)
  }
  
  var rerollButtons: some View {
    HStack {
      Button("Failures") {
        reroll(strategy: .rerollFailures)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowRerollingFailures || rolling)
      
      Button("Criticals") {
        reroll(strategy: .maximizeCriticals)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowMaximizingCriticals || rolling)
      
      Button("Messy") {
        reroll(strategy: .avoidMessyCritical)
      }
      .buttonStyle(BoldButton(color: .blue))
      .disabled(!viewModel.allowAvoidingMessyCriticals || rolling)
    }
  }
  
  var body: some View {
    VStack(spacing: 15) {
      // Menus
      HStack(alignment: .top) {
        poolMenu
        hungerMenu
        difficultyMenu
      }
      .autoscaling()
      
      rollButton
      
      if let diceBag = viewModel.diceBag {
        RollResultView(diceBag: diceBag)
          .padding(.vertical)
      } else {
        Spacer()
        Text("Nothing rolled yet.")
          .foregroundColor(.secondary)
        Spacer()
      }
      
      Text("Re-roll Strategy")
        .font(.title2.smallCaps())
      rerollButtons
    }
    .padding()
    .onAppear {
      if shouldRollOnAppear {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          self.roll()
        }
      }
    }
  }
  
  func roll() {
    runHaptics(taps: 10)
    performOperation(count: 5, operation: viewModel.roll)
  }
  
  func reroll(strategy: DiceBag.RerollStrategy) {
    runHaptics(taps: 5)
    performOperation(count: 5) {
      viewModel.reroll(strategy: strategy)
    }
  }
  
  /// Perform an operation a specified number of times.
  ///
  /// The buttons are disabled for the duration.
  ///
  /// This method has to be in the view, not the view model, because
  /// of the button state animations.
  /// - Parameters:
  ///   - count: The number of times to perform the operation.
  ///   - operation: The
  private func performOperation(
    count: Int,
    operation: @escaping () -> ()
  ) {
    var phonyRolls = 0
    
    withAnimation(.easeInOut(duration: 0.1)) {
      rolling = true
    }
    
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
      operation()
      phonyRolls += 1
      
      if phonyRolls == count {
        timer.invalidate()
        
        withAnimation(.easeInOut(duration: 0.1)) {
          rolling = false
        }
      }
    }
  }
  
  func diceLabel(_ label: LocalizedStringKey, value: Int) -> some View {
    VStack {
      HStack(spacing: 0) {
        Text("\(value / 10)")
          .opacity(value < 10 ? 0.15 : 1)
        Text("\(value % 10)")
      }
      .font(.system(size: 700, weight: .black, design: .monospaced))
      .overlay(
        Rectangle()
          .frame(height: 5)
          .padding(.top, -15),
        alignment: .bottom
      )
      
      Text(label)
        .font(.system(size: 200, design: .monospaced))
    }
  }
  
  /// Tap the user a bunch of times with decreasing intensity.
  /// - Parameter taps: The number of times to tap.
  func runHaptics(taps: Int) {
    var events: [CHHapticEvent] = []
    
    for i in stride(from: 0, to: 1, by: 1 / Double(taps)) {
      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
      let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i / 2)
      events.append(event)
    }
    
    do {
      try engine?.start()
      let pattern = try CHHapticPattern(events: events, parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      try player?.start(atTime: 0)
    } catch {
      print("Failed to play pattern: \(error.localizedDescription).")
    }
  }
}

struct DiceRoller_Previews: PreviewProvider {
  static var previews: some View {
    DiceRoller()
  }
}
