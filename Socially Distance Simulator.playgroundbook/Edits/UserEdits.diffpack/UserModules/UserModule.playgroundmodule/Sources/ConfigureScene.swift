
import SpriteKit
import SwiftUI

/* this is the SKScene in with the configuration is loaded on. it houses the ConfigureView as well */
public class ConfigureScene: SKScene {
    
    // Transition to simulation screen
    func nextScene() {
        // Inspiration taken from:
        // https://stackoverflow.com/questions/41649446/swift-3-spritekit-reseting-the-gamescene-after-the-game-ends
        
        let screen = UIScreen.main.bounds.size
        let nextScene = GameScene(size: self.scene!.size)
        nextScene.scaleMode = self.scaleMode
        nextScene.backgroundColor = #colorLiteral(red: 0.2549019607843137, green: 0.27450980392156865, blue: 0.30196078431372547, alpha: 1.0)
        
        // Menu Bar
        let menuBar = MenuBar()
        let controller = UIHostingController(rootView: menuBar)
        controller.view.frame = CGRect(x: screen.width, y: 100, width: 0, height: 0)
        
        // Graph
        let graph = GraphView()
        let graphController = UIHostingController(rootView: graph)
        graphController.view.frame = CGRect(x: screen.width, y: screen.height*2 - 20, width: 0, height: 0)
        
        // Present the scene
        self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.5))
        
        // Remove all the current subviews
        UIView.transition(with: self.view!, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view?.subviews.forEach({ $0.removeFromSuperview() })
        }, completion: nil)
        
        // Add the new subviews
        UIView.transition(with: self.view!, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view?.addSubview(controller.view) 
            self.view?.addSubview(graphController.view)
        }, completion: nil) 
        
        // Reset the data
        GraphViewModel.sharedInstance().reset()
        SharedData.shared().reset()
        MenuBarModel.sharedInstance().reset()
    }
}

// SwiftUI part of the screen
public struct ConfigureView: View {
    
    public init() {}
    
    public var configScene: ConfigureScene?
    
    // Toggles
    @State public var enableRealism = false
    @State public var asymp = false
    @State public var nodes = 35
    @State public var speed: Double = 3
    @State public var recover = false
    @State public var sd = false
    @State public var fd = false
    @State public var gm = false
    @State public var sdpercent = 50
    
    public var body: some View {
        VStack(spacing: 30.0) {
            Text("Start new simulation.").font(.title).fontWeight(.semibold)
            HStack {
                Stepper(value: $nodes, in: 5...100, label: {Text("Number of people (dots)")})
                Text("\(nodes)")
            }
            VStack {
                Slider(value: $speed, in: 1...5, step: 1)
                Text("Speed Level: \(Int(speed))")
            }
            Toggle(isOn: $asymp) {
                Text("Enable asymptomatic people?")
            }
            Toggle(isOn: $recover) {
                Text("Enable people to recover?")
            }
            Toggle(isOn: $sd) {
                Text("Enable Social Distancing?")
            }
            if (sd) {
                HStack {
                    Stepper(value: $sdpercent, in: 15...85, label: {Text("Social Distancing Percentage")})
                    Text("\(sdpercent)")
                }
            }
            Toggle(isOn: $fd) {
                Text("Enable Forced Distancing?")
            }
            Toggle(isOn: $gm) {
                Text("Enable game mode?")
            }
            Button(action: {
                // Send configuration data to the SharedData
                SharedData.shared().totalDots = self.nodes
                SharedData.shared().setSpeed(speed: Int(self.speed))
                SharedData.shared().canRecover = self.recover
                SharedData.shared().hasAsymp = self.asymp
                SharedData.shared().socialDistance = self.sd
                SharedData.shared().forceDistance = self.fd
                SharedData.shared().gamingMode = self.gm
                SharedData.shared().socialDistancePercent = self.sdpercent
                // Call next scene
                self.configScene?.nextScene()
            }) {
                Text("Start")
            }.frame(width: 100.0, height: 30.0).background(Color.white).cornerRadius(/*@START_MENU_TOKEN@*/14.0/*@END_MENU_TOKEN@*/).foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
            
        }
        .frame(minWidth: 0, maxWidth: 800, minHeight: 0, maxHeight: .infinity)
        .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.0, opacity: 0.8))
        .environment(\.colorScheme, .dark)
    }
}



