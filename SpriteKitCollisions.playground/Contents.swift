import SpriteKit
import PlaygroundSupport

class Scene: SKScene, SKPhysicsContactDelegate {
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Block: UInt32 = 0b1 << 1
    }
    
    override func didMove(to view: SKView) {
        super.size = CGSize(width: 1920, height: 1080)
        
        super.physicsWorld.contactDelegate = self
        
        super.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let sceneBound = SKPhysicsBody(edgeLoopFrom: super.frame)
        sceneBound.friction = 0
        sceneBound.restitution = 1
        super.physicsBody = sceneBound
        
        let ball = SKSpriteNode(color: SKColor.white, size: CGSize(width: 50, height: 50))
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        ball.physicsBody!.allowsRotation = false
        ball.physicsBody!.categoryBitMask = CategoryBitMask.Ball
        ball.physicsBody!.contactTestBitMask = CategoryBitMask.Block
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.velocity = CGVector(dx: 1000, dy: 1000)
        ball.position = CGPoint(x: 0.5 * super.size.width, y: 0.5 * super.size.height)
        super.addChild(ball)
        
        let block = SKSpriteNode(color: SKColor.white, size: CGSize(width: 150, height: 50))
        block.name = "Block"
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody!.categoryBitMask = CategoryBitMask.Block
        block.physicsBody!.isDynamic = false
        block.physicsBody!.friction = 0
        block.physicsBody!.restitution = 1
        
        for y in 1...3 {
            for x in 1...11 {
                let b = block.copy() as! SKSpriteNode
                b.position = CGPoint(x: (b.size.width + 10) * CGFloat(x), y: (b.size.height + 10) * CGFloat(y))
                super.addChild(b)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CategoryBitMask.Ball && contact.bodyB.categoryBitMask == CategoryBitMask.Block {
            let block = contact.bodyB.node as! SKSpriteNode
            
            if block.name == "Block" {
                block.color = SKColor.darkGray
                block.name = "HalfBlock"
            }
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
