
import SwiftUI

// The little transport that brings our data from the model to the view
struct BarContainer: Hashable {
    var infected = 0
    var recovered = 0
}

// Gets data for the Graph View
class GraphViewModel: ObservableObject {
    
    private static var instance: GraphViewModel = GraphViewModel()
    @Published var barValues: [BarContainer] = [BarContainer]()
    
    init() {
        reset()
    }
    
    func reset() {
        barValues = [BarContainer]()
    }
    
    func addValues(infected: Int, recovered: Int) {
        var structToAdd = BarContainer()
        structToAdd.infected = infected
        structToAdd.recovered = recovered
        barValues.append(structToAdd)
    }
    
    class func sharedInstance() -> GraphViewModel {
        return instance
    }
}
