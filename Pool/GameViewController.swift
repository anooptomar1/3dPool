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
    private let cameraNode = SCNNode()
    
    @IBOutlet weak var btnReset: NSButton!
    @IBOutlet weak var btnHit: NSButton!
    
    override func keyUp(with event: NSEvent) {
        KeyPressHandler.handle(event, cameraNode)
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
        
        cameraNode.camera = SCNCamera()
        resetCameraAction(self)
        scene.rootNode.addChildNode(cameraNode)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 30, y: 15, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light!.type = .omni
        lightNode2.position = SCNVector3(x: -30, y: 15, z: 0)
        scene.rootNode.addChildNode(lightNode2)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        rackBalls()
        
        // set the scene to the view
        gameView!.scene = scene
        
        // allows the user to manipulate the camera
//        gameView!.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        gameView!.showsStatistics = true
        
        // configure the view
        gameView!.backgroundColor = NSColor.black
        
        gameView!.cueBallNode = ballNodes[0]
        gameView!.rootNode = scene.rootNode
    }
    
    private func rackBalls() {
        Rack.rack(ballNodes)
    }
    
    @IBAction func hitAction(_ sender: Any) {
        
        let force = gameView!.dirV!
//        let force = SCNVector3(x: -10, y: 0 , z: -50)
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
        
                cameraNode.position = SCNVector3(x: 0, y: 20, z: 30)
        
//                let yRot = SCNMatrix4MakeRotation(CGFloat(Double.pi), 0, 1, 0)
                let xRot = SCNMatrix4MakeRotation(CGFloat(Double.pi / 4), 1, 0, 0)
//
//                let m = SCNMatrix4Mult(xRot, yRot)
                cameraNode.pivot = xRot
        
        cameraNode.camera?.xFov = 50
        cameraNode.camera?.yFov = 50
    }
}
