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
    
    var rootNode: SCNNode?
    var cueBallNode: SCNNode?
    
    var targetBallNode: SCNNode?
    var dirV: SCNVector3?

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
        
        drawCuePath()
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
        
        dirV = directionVector(v1!, v2!)
    }
    
    func directionVector(_ v1: SCNVector3, _ v2: SCNVector3) -> SCNVector3 {
        let x = v2.x - v1.x
        let y = v2.y - v1.y
        let z = v2.z - v1.z
        
        return SCNVector3(x: x, y: y, z: z)
    }
}
