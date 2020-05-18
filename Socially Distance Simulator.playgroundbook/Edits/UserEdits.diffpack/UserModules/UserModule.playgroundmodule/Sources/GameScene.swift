
import SpriteKit
import SwiftUI
import UIKit

// The "brains" of the program, the main simulation scene.
public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let numberOfDots = SharedData.shared().totalDots
    var rootDot: SKShapeNode!
    var circleTouch: UITouch?
    var allDots = [SKShapeNode]()
    var gameOver = false
    var movingPlayer = false
    var offset: CGPoint!
    
    // Sets up the screen
    public override func didMove(to view: SKView) {
        
        // Set up the graph notifications, every half a second.
        let wait = SKAction.wait(forDuration: 0.5)
        let update = SKAction.run(
        {
            // We should stop graphing if everyone's infected, or if nobody is infected.
            if (MenuBarModel.sharedInstance().infectedNumber == SharedData.shared().totalDots) {
                self.createLabel(message: "All people are infected. Click refresh to reset.")
                self.removeAction(forKey: "update")
            }else if (MenuBarModel.sharedInstance().infectedNumber == 0) {
                self.createLabel(message: "No people are infected. Click refresh to reset.")
                self.removeAction(forKey: "update")
            }
            else {
                if (SharedData.shared().canRecover) {
                    GraphViewModel.sharedInstance().addValues(infected: MenuBarModel.sharedInstance().infectedNumber, recovered: MenuBarModel.sharedInstance().recoveredNumber)
                } else {
                    GraphViewModel.sharedInstance().addValues(infected: MenuBarModel.sharedInstance().infectedNumber, recovered: 0)
                }
            }
            }
        )
        let seq = SKAction.sequence([wait,update])
        let keepRepeating = SKAction.repeatForever(seq)
        run(keepRepeating, withKey: "update")
        
        // Create the ResetButton
        let button = ResetButtonNode()
        button.name = "button"
        button.position = CGPoint(x: frame.width - 50, y: 50)
        button.delegate = self
        addChild(button)
        
        // Create the rigid distancing boundries if enabled
        if (SharedData.shared().forceDistance) {
            createBoundries()
        }
        
        // Create player if we're in gaming mode 
        if (SharedData.shared().gamingMode) {
            createPlayer()
        }
        
        // Bounce around the body
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0 // bounce around without losing momentum
        physicsWorld.contactDelegate = self
        
    
        // Set the dynamic dots to all, unless we are socially distancing, take the percentage from configuration.
        var dynamicDots:Double = Double(numberOfDots)
        if (SharedData.shared().socialDistance) {
            dynamicDots = dynamicDots * 0.01 * Double(SharedData.shared().socialDistancePercent)
        }
        
        // Create the dots
        for counter in 1...numberOfDots {
            if (counter <= Int(dynamicDots)) {
                createOtherDots(isStatic: false) // parameter will determine if the dot is static or moving.
            } else {
                createOtherDots(isStatic: true)
            }
        }
        
        // Apply impulse
        for dot in allDots {
            if (dot.physicsBody?.isDynamic == true) {
                var dxDirection:CGFloat = 0
                var dyDirection:CGFloat = 0
                
                // Get a random direction, ensure that they are moving at least in one direction
                while (dxDirection == 0 && dyDirection == 0) {
                    dxDirection = CGFloat(chooseRandom(dot: dot))
                    dyDirection = CGFloat(chooseRandom(dot: dot))
                }
                
                dot.physicsBody?.applyImpulse(CGVector(dx: dxDirection, dy: dyDirection))
            }
        }
        
        // Choose a random dot to infect
        let infectedDot = allDots[Int(arc4random_uniform(UInt32(allDots.count)))]
        infectedDot.fillColor = .red
        infectedDot.physicsBody?.categoryBitMask = Bitmasks.infected
        (infectedDot.children.first as? SKShapeNode)?.strokeColor = .red
        
        // if they can recover from configuration, set up the SKAction
        if (SharedData.shared().canRecover) {
        run(SKAction.sequence([
            SKAction.wait(forDuration: 10),
            SKAction.fadeIn(withDuration: 0.5),
            SKAction.run( {
                infectedDot.fillColor = .systemGreen
                infectedDot.physicsBody?.categoryBitMask = Bitmasks.cannotInteract
                MenuBarModel.sharedInstance().updateRecovery()
            })
        ]))}
    }
    
    // creates the rigid boundries 
    func createBoundries() {
        let screen = UIScreen.main.bounds.size
        
        // Bottom boundry
        let boundry1 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10, height: 300))
        boundry1.position = CGPoint(x: screen.width / 4, y: screen.height / 4)
        boundry1.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 300))
        boundry1.physicsBody?.isDynamic = false
        boundry1.physicsBody?.affectedByGravity = false
        boundry1.physicsBody?.allowsRotation = false
        boundry1.zPosition = 1
        
        // Top boundry
        let boundry2 = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10, height: 300))
        boundry2.position = CGPoint(x: screen.width / 4, y: (screen.height / 4) * 3)
        boundry2.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 300))
        boundry2.physicsBody?.isDynamic = false
        boundry2.physicsBody?.affectedByGravity = false
        boundry2.physicsBody?.allowsRotation = false
        boundry2.zPosition = 1
        
        
        boundry1.run(SKAction.moveTo(y: 20, duration: 8.0))
        boundry2.run(SKAction.moveTo(y: screen.height - 20, duration: 8.0))
        
        addChild(boundry1)
        addChild(boundry2)
    }
    
    // Used to choose a random direction for the initial impulse to occur
    func chooseRandom(dot: SKShapeNode) -> Double {
        let isNeg = Bool.random()
        let ommit = Bool.random()
        if (ommit) {
            return 0
        }
        var impulse = dot.physicsBody!.mass * CGFloat(SharedData.shared().velocity)
        if (isNeg) {
            return Double(impulse * -1)
        } else {
            return Double(impulse)
        }
    }
    
    // create player if gamemode is on
    func createPlayer() {
        
        rootDot = SKShapeNode(circleOfRadius: 8)
        rootDot.fillColor = .orange
        rootDot.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(rootDot)
        
        rootDot.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        rootDot.physicsBody?.isDynamic = false
        rootDot.physicsBody?.categoryBitMask = Bitmasks.player
        rootDot.physicsBody?.contactTestBitMask = Bitmasks.infected
    }
    
    // Create all other dots in the scene
    func createOtherDots(isStatic: Bool) {
        
        let dot = SKShapeNode(circleOfRadius: 8)
        dot.fillColor = .gray
        
        dot.position = CGPoint(x: positionWithin(range: 0.8, containerSize: size.width), y: positionWithin(range: 0.8, containerSize: size.height))
        
        // If gaming mode, ensure that the dot is not on top of the player dot
        if (SharedData.shared().gamingMode) {
            while distanceFrom(posA: dot.position, posB: rootDot.position) < dot.frame.width {
                dot.position = CGPoint(x: positionWithin(range: 0.8, containerSize: size.width), y: positionWithin(range: 0.8, containerSize: size.height))
            }
        }
        
        dot.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        dot.physicsBody?.affectedByGravity = false
        dot.physicsBody?.allowsRotation = false
        dot.physicsBody?.categoryBitMask = Bitmasks.uninfectedPerson
        dot.physicsBody?.contactTestBitMask = Bitmasks.infected
        if (isStatic) {
            // Make sure the socially distancing dots don't move!
            dot.physicsBody?.pinned = true
        } else  {
            dot.physicsBody?.friction = 0.0
            dot.physicsBody?.angularDamping = 0.0
            dot.physicsBody?.restitution = 1.0
        }
        addChild(dot)
        allDots.append(dot)
    }
    
    // Touch handeling functions for the game mode
    // Inspiration taken from
    // https://stackoverflow.com/questions/28176324/dragging-of-skshapenode-not-smooth
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else { return }
        movingPlayer = true
        
        for touch in touches {
            if atPoint(touch.location(in: self)) == rootDot {
                circleTouch = touch as? UITouch
            }
        }
        
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver && movingPlayer else { return }
        
        for touch in touches {
            if circleTouch != nil {
                if touch as UITouch == circleTouch! {
                    let location = touch.location(in: self)
                    rootDot.run(SKAction.move(to: location, duration: 0.01))
                }
            }
        }
    } 
    
public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
 movingPlayer = false
    for touch in touches {
        if circleTouch != nil {
            if touch as UITouch == circleTouch! {
                circleTouch = nil
            }
        }
    }
 } 
    
    // Detected a collision!
    public func didBegin(_ contact: SKPhysicsContact) {
        
        // This is to ensure the dots don't slow down. Give them a little kick.
        let lengthA = hypotf(Float(contact.bodyA.velocity.dx), Float(contact.bodyA.velocity.dy)) 
        let multiplierA = (Float(SharedData.shared().velocity) / lengthA) // smaller = slower
        contact.bodyA.velocity.dx *= CGFloat(multiplierA)
        contact.bodyA.velocity.dy *= CGFloat(multiplierA)
        
        // Same thing with the other dot
        let lengthB = hypotf(Float(contact.bodyB.velocity.dx), Float(contact.bodyB.velocity.dy)) 
        let multiplierB = (Float(SharedData.shared().velocity) / lengthB)
        contact.bodyB.velocity.dx *= CGFloat(multiplierB)
        contact.bodyB.velocity.dy *= CGFloat(multiplierB)
        
        // Check what type of contact it is
        if contact.bodyA.categoryBitMask == Bitmasks.uninfectedPerson && contact.bodyB.categoryBitMask == Bitmasks.infected {
            infect(dot: contact.bodyA.node as! SKShapeNode)
        } else if contact.bodyB.categoryBitMask == Bitmasks.uninfectedPerson && contact.bodyA.categoryBitMask == Bitmasks.infected {
            infect(dot: contact.bodyB.node as! SKShapeNode)
        } else if contact.bodyA.categoryBitMask == Bitmasks.player || contact.bodyB.categoryBitMask == Bitmasks.player {
            triggerGameOver(message: "Infected! Game over.")
        }
    }
    
    // Change the dot to be infected
    func infect(dot: SKShapeNode) {
        
        // Update the top bar
        MenuBarModel.sharedInstance().updateTotals()
        
        // If Asymptomatic is enabled, determine if we should show the user that the user is infected.
        if (SharedData.shared().hasAsymp) {
            var random = Int.random(in: 1...100) 
            if (random % 2 == 1) {
                dot.fillColor = .red
            }
        } else {
            dot.fillColor = .red
        }
        
        dot.physicsBody?.categoryBitMask = Bitmasks.infected
        (dot.children.first as? SKShapeNode)?.strokeColor = .red
        
        // Inspiration taken from:
        // https://stackoverflow.com/questions/23978209/spritekit-creating-a-timer
        if (SharedData.shared().canRecover) {
            run(SKAction.sequence([
                SKAction.wait(forDuration: 10),
                SKAction.fadeIn(withDuration: 0.5),
                SKAction.run( {
                    dot.fillColor = .systemGreen
                    dot.physicsBody?.categoryBitMask = Bitmasks.cannotInteract
                    MenuBarModel.sharedInstance().updateRecovery()
                })
            ]))
        }
    }
    
    // Game is over for the player
    func triggerGameOver(message: String) {
        createLabel(message: message)
            run(SKAction.sequence([
                SKAction.wait(forDuration: 3),
                SKAction.run( {
                    self.resetScene()
                })
            ]))
    }
    
    // Show the user that the simulation is virtually over
    func createLabel(message: String) {
        gameOver = true
        
        let gameOverLbl = SKLabelNode(text: message)
        gameOverLbl.fontSize = 30.0
        gameOverLbl.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLbl.zPosition = 3
        gameOverLbl.fontColor = .white
        addChild(gameOverLbl)
    }
    
    // Reset/transfer the scene to configuration
    func resetScene() {
        // Configure the view.
        //https://stackoverflow.com/questions/41649446/swift-3-spritekit-reseting-the-gamescene-after-the-game-ends
        
        // remove the skscene views
        self.removeAllChildren()
        
        // prepare the configuration scene
        let screen = UIScreen.main.bounds.size
        let nextScene = ConfigureScene(size: self.scene!.size)
        nextScene.scaleMode = self.scaleMode
        nextScene.backgroundColor = UIColor(hue: 1.0, saturation: 0.0, brightness: 0.0, alpha: 0.8)
        
        // configuration UI
        var configureView = ConfigureView()
        configureView.configScene = nextScene
        let configControl = UIHostingController(rootView: configureView)
        configControl.view.backgroundColor = UIColor(hue: 1.0, saturation: 0.0, brightness: 0.0, alpha: 0.8)
        configControl.view.frame = CGRect(x: 0, y: 0, width: screen.width*2, height: screen.height*2)
        
            // Present next scene
        self.view?.presentScene(nextScene, transition: SKTransition.fade(with: UIColor.black, duration: 0.5))
        
            // remove the subviews from this scene
        UIView.transition(with: self.view!, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view?.subviews.forEach({ $0.removeFromSuperview() })
        }, completion: nil)
        
            // prepare the new subview
        UIView.transition(with: self.view!, duration: 0.5, options: [.transitionCrossDissolve], animations: {
            self.view?.addSubview(configControl.view) 
        }, completion: nil)
        
            // reset the data
        SharedData.shared().reset()
        MenuBarModel.sharedInstance().reset()
    }
    
    // Mathematical helper functions
    func positionWithin(range: CGFloat, containerSize: CGFloat) -> CGFloat {
        let x = CGFloat(arc4random_uniform(100)) / 100.0
        let y = (containerSize * (1.0 - range) * 0.5)
        let z = (containerSize * range + y)
        
        return x * z
    }
    
    func distanceFrom(posA: CGPoint, posB: CGPoint) -> CGFloat {
        let aSquared = (posA.x - posB.x) * (posA.x - posB.x)
        let bSquared = (posA.y - posB.y) * (posA.y - posB.y)
        
        return sqrt(aSquared + bSquared)
    }
}

