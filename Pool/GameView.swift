//
//  GameView.swift
//  Pool
//
//  Created by Kay Ven on 8/4/17.
//  Copyright (c) 2017 anon. All rights reserved.
//

import SceneKit

class GameView: SCNView {
    
    var clickPt: NSPoint = NSPoint(x: 0, y: 0)
    
    var cueBallNode: SCNNode?
    var targetBallNode: SCNNode?
    var rootNode: SCNNode?
    
    override func mouseDown(with theEvent: NSEvent) {
        /* Called when a mouse click occurs */
        
        let eventLocation = theEvent.locationInWindow
//        Swift.print("InWin", eventLocation)
        
//        let center = self.convertPoint:eventLocation fromView:nil];
        clickPt = self.convert(eventLocation, from: nil)
//        Swift.print("InHere", clickPt)
        
        
        
//        [self setNeedsDisplay:YES];
//        clickPt = theEvent.abs
        
        super.mouseDown(with: theEvent)
        
//        drawCuePath()
    }
    
    private func drawCuePath() {
        
        // check what nodes are clicked
        
        let hitResults = self.hitTest(clickPt, options: [:])
        
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            targetBallNode = result.node!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
            
            
        }
        
        let v1 = cueBallNode?.position
        let v2 = targetBallNode?.position
        
        let line = CylinderLine(targetBallNode!, v1!, v2!, 0.01, 25, NSColor.red)
        rootNode?.addChildNode(line)
    }
    
}

class   CylinderLine: SCNNode
{
    init( _ parent: SCNNode,//Needed to add destination point of your line
        _ v1: SCNVector3,//source
        _ v2: SCNVector3,//destination
        _ radius: CGFloat,//somes option for the cylinder
        _ radSegmentCount: Int, //other option
        _ color: NSColor )// color of your node object
    {
        super.init()
        
        //Calcul the height of our line
        let  height = v1.distance(receiver: v2)
        
        //set position to v1 coordonate
        position = v1
        
        //Create the second node to draw direction vector
        let nodeV2 = SCNNode()
        
        //define his position
        nodeV2.position = v2
        //add it to parent
        parent.addChildNode(nodeV2)
        
        //Align Z axis
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = CGFloat(M_PI_2)
        
        //create our cylinder
        let cyl = SCNCylinder(radius: radius, height: CGFloat(height))
        cyl.radialSegmentCount = radSegmentCount
        cyl.firstMaterial?.diffuse.contents = color
        
        //Create node with cylinder
        let nodeCyl = SCNNode(geometry: cyl )
        nodeCyl.position.y = CGFloat(-height/Float(2))
        zAlign.addChildNode(nodeCyl)
        
        //Add it to child
        addChildNode(zAlign)
        
        //set contrainte direction to our vector
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
