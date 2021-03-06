import SpriteKit

// Reset button. This is mostly not my work.

public class ResetButtonNode: SKSpriteNode {
    
    // MARK: Properties
    
    weak var delegate: ResetButtonNodeDelegate?
    
    // MARK: Lifecycle
    
    init() {
        let texture = SKTexture(image: #imageLiteral(resourceName: "icons8-reset-64.png")) // this image was taken from online, so I didn't have to create a graphic myself. Source: https://icons8.com/icons/set/reset
        let color = SKColor.red
        let size = CGSize(width: 30, height: 30)
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
        zPosition = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Touch Handling
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.5
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        let location = touches.first!.location(in: self)
        if location.isInside(node: self) {
            let alphaAction = SKAction.fadeAlpha(to: 0.5, duration: 0.10)
            alphaAction.timingMode = .easeInEaseOut
            run(alphaAction)
        }
        else {
            performButtonAppearanceResetAnimation()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        performButtonAppearanceResetAnimation()
        
        let location = touches.first!.location(in: self)
        if location.isInside(node: self) {
            // Touch Up Inside
            delegate?.didTapReset(sender: self)
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        performButtonAppearanceResetAnimation()
    }
    
    // MARK: Helper Functions
    
    func performButtonAppearanceResetAnimation() {
        let alphaAction = SKAction.fadeAlpha(to: 1.0, duration: 0.10)
        alphaAction.timingMode = .easeInEaseOut
        run(alphaAction)
    }
    
}



// MARK: ResetButtonNodeDelegate

protocol ResetButtonNodeDelegate: class {
    func didTapReset(sender: ResetButtonNode)
}

