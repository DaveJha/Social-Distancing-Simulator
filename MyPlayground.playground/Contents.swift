//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

/*:
# Welcome to Playgrounds
This is your *first* playground which is intented to demonstrate:
* The use of **Quick Look**
* Placing results **in-line** with the code
*/

let view = SKView(frame: CGRect(x: 0, y: 0, width: 960, height: 540))

scene.scaleMode = .aspectFit

view.presentScene(scene)
PlaygroundPage.current.liveView = view
