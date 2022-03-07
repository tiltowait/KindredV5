//
//  AdvantageOptionViewModel.swift
//  Kindred
//
//  Created by Jared Lindsay on 6/21/21.
//

import Foundation

extension AdvantageOptionView {
  class ViewModel: OptionalKindredViewModel {
    
    enum Status {
      case contained
      case uncontained
      case inapplicable
    }
    
    @Published var option: AdvantageOption
    var container: AdvantageContainer?
    
    @Published var currentRating: Int16 {
      willSet {
        container?.currentRating = newValue
      }
    }
    
    @Published var showingUnlockSheet = false {
      didSet {
        isUnlocked = dataController!.isPurchased(item: option)
      }
    }
    @Published var isUnlocked: Bool
    
    let isSingleOption: Bool
    let singleOptionMagnitude: Int?
    
    var status: Status {
      if dataController != nil && container == nil {
        if let advantages = kindred?.advantageContainers.map({ $0.option }) {
          if advantages.contains(option) {
            return .contained
          }
          return .uncontained
        }
      }
      return .inapplicable
    }
    
    // MARK: - Rating Modification
    
    var showRatingRange: Bool {
      // If there is a container, that means a current rating has been assigned, so we will
      // display it in a selector view
      container == nil && !isSingleOption && isUnlocked
    }
    
    var showRatingSelection: Bool {
      container != nil && !isSingleOption && isUnlocked
    }
    
    // Minimum and maximum rating are defined in terms of magnitude, not strict numerical
    // value. Therefore, a flaw might have a "minimum" value of -1 and a "maximum" of -5.
    // In order for ClosedRanges to work, we need to do some conversion so that Swift won't
    // complain and crash on us.
    
    var minAllowableRating: Int16 {
      if option.isFlaw {
        return option.maxRating
      }
      return option.minRating
    }
    
    var maxAllowableRating: Int16 {
      if option.isFlaw {
        return option.minRating
      }
      return option.maxRating
    }
    
    // MARK: - Initializers and Methods
    
    init(option: AdvantageOption, kindred: Kindred?, dataController: DataController) {
      self.option = option
      self.container = nil
      self.currentRating = -1 // We don't need this
      
      isSingleOption = option.minRating == option.maxRating
      singleOptionMagnitude = isSingleOption ? Int(abs(option.maxRating)) : nil
      isUnlocked = dataController.isPurchased(item: option)
      
      super.init(kindred: kindred, dataController: dataController)
      
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(userMadePurchase),
        name: .userDidPurchaseItem, object: nil
      )
    }
    
    init(container: AdvantageContainer, dataController: DataController) {
      self.container = container
      self.option = container.option
      self.currentRating = container.currentRating
      
      isSingleOption = container.option.minRating == container.option.maxRating
      singleOptionMagnitude = isSingleOption ? Int(abs(container.option.maxRating)) : nil
      isUnlocked = dataController.isPurchased(item: container.option)
      
      super.init(kindred: container.kindred, dataController: dataController)
    }
    
    func addToCharacter() {
      guard let kindred = kindred,
         let dataController = dataController
      else { return }
      
      let container = AdvantageContainer(context: dataController.container.viewContext)
      container.refID = option.id
      container.currentRating = option.minRating
      kindred.addToAdvantages(container)
      
      NotificationCenter.default.post(name: .didAddAdvantage, object: nil)
    }
    
    /// Observe when the user makes a purchase so we can update our containers.
    /// - Parameter notification: The purchase notification
    @objc func userMadePurchase(_ notification: Notification) {
      isUnlocked = dataController!.isPurchased(item: option)
    }
    
  }
}
