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
        
        let v1 = cueBallNode?.presentation.position
        let v2 = targetBallNode?.presentation.position
        
        dirV = directionVector(v1!, v2!)
    }
    
    func directionVector(_ v1: SCNVector3, _ v2: SCNVector3) -> SCNVector3 {
        let x = v2.x - v1.x
        let y = v2.y - v1.y
        let z = v2.z - v1.z
        
        let dv = SCNVector3(x: x, y: y, z: z)
//        Swift.print(v1, v2, dv)
        
        let mag = magnitude(dv)
        let max: CGFloat = 25, min: CGFloat = 5
        
        if (mag < min) {
            return scaleVector(dv, 2 * (min/mag))
        }
        return dv
    }
    
    func magnitude(_ v: SCNVector3) -> CGFloat {
        
        let x2 = v.x * v.x
        let y2 = v.y * v.y
        let z2 = v.z * v.z
        
        let mag = sqrt(x2 + y2 + z2)
        Swift.print("mag=", mag)
        return mag
    }
    
    func normalizeVector(_ v: SCNVector3) -> SCNVector3 {
//        Swift.print("\nDirV", v)
        let x = v.x
        let z = v.z
        let ax = abs(x)
        let az = abs(z)
        
        let max = ax > az ? x : z
        
        let nx = x / abs(max)
        let nz = z / abs(max)
        
        let nv = SCNVector3(x: nx, y: 0, z: nz)
//        Swift.print("\nNormV", nv)
        return nv
    }
    
    func scaleVector(_ v: SCNVector3, _ factor: CGFloat) -> SCNVector3 {
        let sv = SCNVector3(x: v.x * factor, y: 0, z: v.z * factor)
//        Swift.print("\nScaleVector", sv)
        return sv
    }
}
