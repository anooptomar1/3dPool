//
//  GameViewController.swift
//  Pool
//
//  Created by Kay Ven on 8/4/17.
//  Copyright (c) 2017 anon. All rights reserved.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    private var balls: Balls = Balls.instance()
    private var ballNodes: [SCNNode] = [SCNNode]()
    private var startTime: Date?
    private var racked: Bool = false
    private var hit: Bool = false
    private let cameraNode = SCNNode()
    
    @IBOutlet weak var btnReset: NSButton!
    @IBOutlet weak var btnHit: NSButton!
    
    //    var scene: SCNScene?
    
    override func keyUp(with event: NSEvent) {
        print(event.keyCode)
        
        let x = cameraNode.position.x
        let y = cameraNode.position.y
        let z = cameraNode.position.z
        
        switch event.keyCode {
        case 123: // Left
                    let nx = x + 1
                    cameraNode.position = SCNVector3(x: nx, y: y, z: z)
        case 124: // Right
            let nx = x - 1
            cameraNode.position = SCNVector3(x: nx, y: y, z: z)
        case 126: // Up
            let nz = z + 1
            cameraNode.position = SCNVector3(x: x, y: y, z: nz)
        case 125: // Down
            let nz = z - 1
            cameraNode.position = SCNVector3(x: x, y: y, z: nz)
        case 24:    // Plus (zoom in)
            let xf = cameraNode.camera?.xFov
            let nxf = xf! - 10
            let yf = cameraNode.camera?.yFov
            let nyf = yf! - 10
            cameraNode.camera?.xFov = nxf
            cameraNode.camera?.yFov = nyf
        case 27:    // Minus (zoom out)
            let xf = cameraNode.camera?.xFov
            let nxf = xf! + 10
            let yf = cameraNode.camera?.yFov
            let nyf = yf! + 10
            cameraNode.camera?.xFov = nxf
            cameraNode.camera?.yFov = nyf
        case 0: print(cameraNode.position)
            print(cameraNode.camera?.xFov, cameraNode.camera?.yFov)
                print(cameraNode.pivot)
        default: print("fuck")
        }
    }
    
    override func awakeFromNib(){
        
        super.awakeFromNib()
        
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/pool.scn")!
        
        let cueBallNode = scene.rootNode.childNode(withName: "cueBall", recursively: false)!
        ballNodes.append(cueBallNode)
        
        for i in 1...15 {
            
            let nodeName = String(i) + "ball"
            let node = scene.rootNode.childNode(withName: nodeName, recursively: true)!
            ballNodes.append(node)
        }
        
        // create and add a camera to the scene
        
        cameraNode.camera = SCNCamera()
        // place the camera
        //        cameraNode.position = SCNVector3(x: 0, y: 13, z: -30)
        
        //        let yRot = SCNMatrix4MakeRotation(CGFloat(Double.pi), 0, 1, 0)
        //        let xRot = SCNMatrix4MakeRotation(CGFloat(Double.pi / 6), -1, 0, 0)
        //
        //        let m = SCNMatrix4Mult(xRot, yRot)
        //        cameraNode.pivot = m
        
        resetCameraAction(self)
        
        scene.rootNode.addChildNode(cameraNode)
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 20, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = .omni
        lightNode2.position = SCNVector3(x: -20, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode2)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = NSColor(red: 0, green: 0.4, blue: 0, alpha: 1)
        groundGeometry.materials = [groundMaterial]
        
        let ground = SCNNode(geometry: groundGeometry)
        ground.position = SCNVector3(x: 0, y: 0, z: 0)
        ground.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        scene.rootNode.addChildNode(ground)
        
        
        
        rackBalls()
        
        // set the scene to the view
        gameView!.scene = scene
        
        // allows the user to manipulate the camera
//        gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        gameView!.showsStatistics = true
        
        startTime = Date()
        
        // configure the view
        //        gameView!.backgroundColor =
    }
    
    private func rackBalls() {
        Rack.rack(ballNodes)
    }
    
    @IBAction func hitAction(_ sender: Any) {
        
        let force = SCNVector3(x: 0, y: 0 , z: 100)
        let position = SCNVector3(x: 0, y: 0, z: 0)
        
        ballNodes[0].physicsBody?.applyForce(force, at: position, asImpulse: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        
        Rack.rack(ballNodes)
    }
    
    @IBAction func resetCameraAction(_ sender: Any) {
//        cameraNode.position = SCNVector3(x: 0, y: 10, z: -10)
//        
//        let yRot = SCNMatrix4MakeRotation(CGFloat(Double.pi), 0, 1, 0)
//        let xRot = SCNMatrix4MakeRotation(CGFloat(Double.pi / 3), -1, 0, 0)
//        
//        let m = SCNMatrix4Mult(xRot, yRot)
//        cameraNode.pivot = m
        
                cameraNode.position = SCNVector3(x: 0, y: 13, z: -30)
        
                let yRot = SCNMatrix4MakeRotation(CGFloat(Double.pi), 0, 1, 0)
                let xRot = SCNMatrix4MakeRotation(CGFloat(Double.pi / 6), -1, 0, 0)
        
                let m = SCNMatrix4Mult(xRot, yRot)
                cameraNode.pivot = m
        
        cameraNode.camera?.xFov = 40
        cameraNode.camera?.yFov = 40
    }
}
