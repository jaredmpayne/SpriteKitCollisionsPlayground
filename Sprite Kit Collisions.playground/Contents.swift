//: # Sprite Kit Collisions Playground
//: This playground demonstrates how do physics perform collision detection using Swift and Sprite Kit.

import SpriteKit
import PlaygroundSupport

//: 1. Set your scene class to inherit from both `SKScene` and `SKPhysicsContactDelegate`.

class Scene: SKScene, SKPhysicsContactDelegate {
    
//: 2. Create a `struct` of `UInt32` binary powers of 2 for all object types you want to detect collisions between.
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Block: UInt32 = 0b1 << 1
        // The next would be `static let ObjectName: UInt32 = 0b1 << 2` and so on.
    }
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 1920, height: 1080)
        
//: 3. Set the scene's physics world's contact delegate to be the scene class.
        
        self.physicsWorld.contactDelegate = self
        
        // Set the scene world's gravity to 0.
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        // Create an invisible barrier around the scene to keep the ball inside.
        let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
        sceneBound.friction = 0
        sceneBound.restitution = 1
        self.physicsBody = sceneBound
        
//: 4. Set the `physicsBody.categoryBitMask` property for each object, and the `physicsBody.contactTestBitMask` property for the object you want to be `bodyA` in collision tests.
        
        // Create a ball to bounce around the scene.
        let ball = SKSpriteNode(color: SKColor.white, size: CGSize(width: 50, height: 50))
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.categoryBitMask = CategoryBitMask.Ball
        ball.physicsBody!.contactTestBitMask = CategoryBitMask.Block
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.velocity = CGVector(dx: 1000, dy: 1000)
        ball.position = CGPoint(x: 0.5 * self.size.width, y: 0.5 * self.size.height)
        self.addChild(ball)
        
        // Create a template for a block.
        let block = SKSpriteNode(color: SKColor.white, size: CGSize(width: 150, height: 50))
        block.name = "Block"
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody!.categoryBitMask = CategoryBitMask.Block
        block.physicsBody!.isDynamic = false
        block.physicsBody!.friction = 0
        block.physicsBody!.restitution = 1
        
        // Place copies of the block template in the scene in a grid-like order.
        for y in 1...3 {
            for x in 1...11 {
                let b = block.copy() as! SKSpriteNode
                b.position = CGPoint(x: (b.size.width + 10) * CGFloat(x), y: (b.size.height + 10) * CGFloat(y))
                self.addChild(b)
            }
        }
    }

//: 5. Add the `- didBeginContact:` function to the class and create `if` blocks to perform actions for specific collision pairs.
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Executed if the ball makes contact with the block.
        if contact.bodyA.categoryBitMask == CategoryBitMask.Ball && contact.bodyB.categoryBitMask == CategoryBitMask.Block {
            let block = contact.bodyB.node as! SKSpriteNode
            
            // Turn the block gray if it hasn't been hit yet.
            if block.name == "Block" {
                block.color = SKColor.darkGray
                block.name = "HalfBlock"
            }

            // Remove the block from the scene if it has already been hit.
            else {
                block.removeFromParent()
            }
        }
    }
}


let scene = Scene()
scene.scaleMode = .aspectFit

let view = SKView(frame: NSRect(x: 0, y: 0, width: 640, height: 360))
view.presentScene(scene)
PlaygroundPage.current.liveView = view
