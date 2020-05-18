import SwiftUI

// Gathers data for the MenuBar
class MenuBarModel: ObservableObject {
    
    private static var instance: MenuBarModel = MenuBarModel()
    
    @Published var infectedNumber: Int = 0
    @Published var healthyNumber: Int = 0
    @Published var recoveredNumber: Int = 0
    
    
    init() {
        reset()
    }
    func updateTotals() {
        infectedNumber += 1
        healthyNumber -= 1
    }
    
    func updateRecovery() {
        infectedNumber -= 1
        recoveredNumber += 1
    }
    
    func reset() {
        infectedNumber = SharedData.shared().infectedNumber
        healthyNumber = SharedData.shared().healthyNumber
    }
    
    class func sharedInstance() -> MenuBarModel {
        return instance
    }
}
