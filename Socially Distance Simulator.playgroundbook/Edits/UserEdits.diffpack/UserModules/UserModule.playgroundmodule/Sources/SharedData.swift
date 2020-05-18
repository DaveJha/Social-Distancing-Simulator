
// A singleton that enables consistent data throughout the playground
public class SharedData {
    
    public var infectedNumber = 1
    public var healthyNumber = 19
    public var totalDots = 30
    public var velocity = 300
    public var canRecover = false
    public var hasAsymp = false
    public var socialDistance = false
    public var forceDistance = false
    public var gamingMode = false
    public var socialDistancePercent = 30
    
    init() {
        reset()
    }
    
    public func reset() {
        healthyNumber = totalDots - 1
        infectedNumber = 1
    }
    
    public func setSpeed(speed: Int) {
        switch speed {
        case 1:
            velocity = 100
        case 2:
            velocity = 200
        case 3:
            velocity = 300
        case 4:
            velocity = 400
        case 5:
            velocity = 500
        default:
            velocity = 500 
        }
    }
    
    // Create a Singleton to be used across the entire game
    private static var sharedInstance = SharedData()
    
    class func shared() -> SharedData {
        return sharedInstance
    }
    
}
