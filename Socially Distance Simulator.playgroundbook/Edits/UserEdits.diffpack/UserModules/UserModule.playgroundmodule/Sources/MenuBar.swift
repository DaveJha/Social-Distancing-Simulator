import SwiftUI

// Top bar displaying totals
public struct MenuBar: View {
    public init() {
        menuBarModel = MenuBarModel.sharedInstance()
    }
    
    @ObservedObject var menuBarModel: MenuBarModel
    
    public var body: some View {
        HStack {
            Spacer()
            Circle()
                .frame(width: 20.0, height: 20.0)
                .foregroundColor(Color.red)
            Text("Infected:")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.white)
            Text(String(self.menuBarModel.infectedNumber))
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.red)
            Spacer()
            Circle()
                .frame(width: 20.0, height: 20.0)
                .foregroundColor(Color.gray)
            Text("Healthy:")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.white)
            Text(String(self.menuBarModel.healthyNumber))
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.gray)
            if (SharedData.shared().canRecover) {
                Spacer()
                Circle()
                    .frame(width: 20.0, height: 20.0)
                    .foregroundColor(Color.green)
                Text("Recovered:")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(Color.white)
                Text(String(self.menuBarModel.recoveredNumber))
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundColor(Color.green)
            }
            Spacer()
        }
        .frame(width: 650, height: 50)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.0, opacity: 0.8))
        .cornerRadius(/*@START_MENU_TOKEN@*/14.0/*@END_MENU_TOKEN@*/)
    }
}
