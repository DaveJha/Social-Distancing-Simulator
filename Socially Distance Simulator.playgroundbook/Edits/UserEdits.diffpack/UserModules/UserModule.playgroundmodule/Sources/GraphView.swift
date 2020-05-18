import SwiftUI

// this configures the graph at the bottom of the screen
// inspiration taken from: https://medium.com/better-programming/swiftui-bar-charts-274e9fbc8030
public struct GraphView: View {
    
    public init() {
        graphViewModel = GraphViewModel.sharedInstance()
    }
    
    @ObservedObject var graphViewModel: GraphViewModel
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(graphViewModel.barValues, id: \.self) {
                data in
                // update the new bar as needed
                BarView(infectedValue: CGFloat(data.infected), recoveredValue: CGFloat(data.recovered))
            }
        }.cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
    }
    
}

// BarView itself
struct BarView: View{
    
    var infected: CGFloat
    var recovered: CGFloat
    var multiplier: CGFloat = 0.0
    var greyHeight: CGFloat = 0.0
    var redHeight: CGFloat = 0.0    
    var greenHeight: CGFloat = 0.0
    
    
    public init(infectedValue: CGFloat, recoveredValue: CGFloat) {
        infected = infectedValue
        recovered = recoveredValue
        multiplier = CGFloat(100/Double(SharedData.shared().totalDots))
        greyHeight = multiplier * CGFloat(SharedData.shared().totalDots)
        
        // We want the heights to be consistent no matter the total
        redHeight = multiplier * infectedValue
        greenHeight = multiplier * recoveredValue
    } 
    
    var body: some View {
        VStack {
            ZStack (alignment: Alignment.bottom) {
                RoundedRectangle(cornerRadius: 0).frame(width: 3, height: greyHeight).foregroundColor(.init(Color(hue: 1.0, saturation: 0.0, brightness: 0.0, opacity: 0.8)))
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: 3, height: redHeight).foregroundColor(.red)
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: 3, height: greenHeight).foregroundColor(.green)
            }.padding(.bottom, 8)
        }
        
    }
}
