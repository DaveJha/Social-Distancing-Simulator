
import SpriteKit

// Houses all extensions that are used 

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}

// Delegate method for notification of reset tapped
extension GameScene: ResetButtonNodeDelegate {
    func didTapReset(sender: ResetButtonNode) {
        resetScene()
    }
}

// CGPoint Extension for Hit Testing

extension CGPoint {
    
    func isInside(node: SKSpriteNode) -> Bool {
        if self.x > -node.size.width/2, self.x < node.size.width/2, self.y > -node.size.height/2, self.y < node.size.height/2 { return true }
        return false
    }
}
