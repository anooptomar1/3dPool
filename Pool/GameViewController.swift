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

        
        addVerticalWedgeForCushionAndRail(scene, "rightNearCushion", "rightNearRail", true)
        addVerticalWedgeForCushionAndRail(scene, "rightNearCushion", "rightNearRail", false)
        
        addVerticalWedgeForCushionAndRail(scene, "rightFarCushion", "rightFarRail", false)
        addVerticalWedgeForCushionAndRail(scene, "rightFarCushion", "rightFarRail", true)
        
        addVerticalWedgeForCushionAndRail(scene, "leftNearCushion", "leftNearRail", true)
        addVerticalWedgeForCushionAndRail(scene, "leftNearCushion", "leftNearRail", false)
        
        addVerticalWedgeForCushionAndRail(scene, "leftFarCushion", "leftFarRail", false)
        addVerticalWedgeForCushionAndRail(scene, "leftFarCushion", "leftFarRail", true)
        
        addHorizontalWedgeForCushionAndRail(scene, "nearCushion", "nearRail", true)
        addHorizontalWedgeForCushionAndRail(scene, "nearCushion", "nearRail", false)
        
        addHorizontalWedgeForCushionAndRail(scene, "farCushion", "farRail", true)
        addHorizontalWedgeForCushionAndRail(scene, "farCushion", "farRail", false)
        
        rackBalls()
        
        // set the scene to the view
        gameView!.scene = scene
        
        // allows the user to manipulate the camera
        gameView!.allowsCameraControl = true
        
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
        
        var dirV: SCNVector3
        if (gameView!.dirV == nil) {
            dirV = gameView!.directionVector((gameView!.cueBallNode?.presentation.position)!, ballNodes[9].presentation.position)
        } else {
            dirV = gameView!.dirV!
        }
        
//        let force = SCNVector3(x: -10, y: 0 , z: -50)
        let strikePoint = (NSApplication.shared().delegate as! AppDelegate).cueBallStrikePoint
        print("sp", strikePoint)
        let position = SCNVector3(x: strikePoint.x, y: strikePoint.y, z: 0)
        
        ballNodes[0].physicsBody?.applyForce(dirV, at: position, asImpulse: true)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        Rack.rack(ballNodes)
    }
    
    @IBAction func resetCameraAction(_ sender: Any) {

        cameraNode.position = SCNVector3(x: 0, y: 20, z: 30)
        let xRot = SCNMatrix4MakeRotation(CGFloat(Double.pi / 4), 1, 0, 0)
        cameraNode.pivot = xRot
        
        cameraNode.camera?.xFov = 50
        cameraNode.camera?.yFov = 50
    }
    
    func addVerticalWedgeForCushionAndRail(_ scene: SCNScene, _ cushionName: String, _ railName: String, _ nearSide: Bool) {
        
        let rail = scene.rootNode.childNode(withName: railName, recursively: true)!
        let cushion = scene.rootNode.childNode(withName: cushionName, recursively: true)!
        
        let bb2 = cushion.boundingBox
        let cl = bb2.max.z - bb2.min.z
//        let cw = bb2.max.x - bb2.min.x
//        let ch = bb2.max.y - bb2.min.y
        
        let bb = rail.boundingBox
        let length = bb.max.z - bb.min.z
        let width = bb.max.x - bb.min.x
        let height = bb.max.y - bb.min.y
        
        let wx = rail.position.x
        let wy = rail.position.y
        let wz = nearSide ? rail.position.z + length / 2 : rail.position.z - length / 2
        
        let wedge = RailWedge.getVerticalWedge(SCNVector3(x: wx, y: wy, z: wz), width, height, (cl - length) / 2, nearSide)
        
        let mat = SCNMaterial()
        mat.locksAmbientWithDiffuse = true
        mat.diffuse.contents = NSColor(red: 0, green: 0.3, blue: 0, alpha: 1)
//        mat.diffuse.contents = NSColor(red: 0.5, green: 0, blue: 0, alpha: 1)
//        mat.diffuse.contents = "art.scnassets/redFelt.jpg"
        mat.specular.contents = NSColor.green
        mat.isDoubleSided = true
        wedge.geometry?.firstMaterial = mat
        
//        wedge.geometry?.firstMaterial?.diffuse.contents = NSColor.blue
//        wedge.geometry?.firstMaterial?.isDoubleSided = true
        
        scene.rootNode.addChildNode(wedge)
    }
    
    func addHorizontalWedgeForCushionAndRail(_ scene: SCNScene, _ cushionName: String, _ railName: String, _ leftSide: Bool) {
        
        let rail = scene.rootNode.childNode(withName: railName, recursively: true)!
        let cushion = scene.rootNode.childNode(withName: cushionName, recursively: true)!
        
        let bb2 = cushion.boundingBox
//        let cl = bb2.max.z - bb2.min.z
                let cw = bb2.max.x - bb2.min.x
        //        let ch = bb2.max.y - bb2.min.y
        
        let bb = rail.boundingBox
        let length = bb.max.z - bb.min.z
        let width = bb.max.x - bb.min.x
        let height = bb.max.y - bb.min.y
        
        let wx = leftSide ? rail.position.x - width / 2 : rail.position.x + width / 2
        let wy = rail.position.y
        let wz = rail.position.z
        
        let wedge = RailWedge.getHorizontalWedge(SCNVector3(x: wx, y: wy, z: wz), (cw - width) / 2, height, length, leftSide)
        
        let mat = SCNMaterial()
        mat.locksAmbientWithDiffuse = true
//        mat.diffuse.contents = NSColor(red: 0.7, green: 0, blue: 0, alpha: 1)
                mat.diffuse.contents = NSColor(red: 0, green: 0.3, blue: 0, alpha: 1)
        //        mat.diffuse.contents = "art.scnassets/redFelt.jpg"
        mat.specular.contents = NSColor.green
        mat.isDoubleSided = true
        wedge.geometry?.firstMaterial = mat
        
        scene.rootNode.addChildNode(wedge)
    }
}
