//
//  Rack.swift
//  Pool
//
//  Created by Kay Ven on 8/5/17.
//  Copyright © 2017 anon. All rights reserved.
//

import Foundation
import SceneKit

class Rack {
    
    static func rack(_ balls: [SCNNode]) {
        
        for i in 0...15 {
            
            // Disable balls
            balls[i].position = SCNVector3(x: 100, y: 0, z: 0)
            
            let deg90 = CGFloat(Double.pi / 2)
            
            balls[i].physicsBody?.velocity = SCNVector3(x: 0, y: 0, z: 0)
            balls[i].physicsBody?.angularVelocity = SCNVector4(x: 0, y: 0, z: 0, w: 0)
            balls[i].eulerAngles = SCNVector3(x: deg90, y: 0, z: deg90)
        }
        
        let radius = Constants.ballRadius
        let diameter = 2 * radius
        let dz = Constants.rack_dz
        
        balls[0].position = SCNVector3(x: 0, y: radius, z: -15)
        
//        balls[1].position = SCNVector3(x: diameter, y: radius, z: 0)
//        balls[2].position = SCNVector3(x: -diameter, y: radius, z: 2 * dz)
//        balls[3].position = BallVector(radius, dz).vector()
//        balls[4].position = BallVector(diameter, 2 * dz).vector()
//        balls[5].position = BallVector(2 * diameter, 2 * dz).vector()
//        balls[6].position = BallVector(-1.5 * diameter, 1 * dz).vector()
//        balls[7].position = BallVector(-0.5 * diameter, -dz).vector()
//        balls[8].position = SCNVector3(x: 0, y: radius, z: 0)
//        balls[9].position = BallVector(0, -2 * dz).vector()
//        balls[10].position = BallVector(-0.5 * diameter, dz).vector()
//        balls[11].position = BallVector(-2 * diameter, 2 * dz).vector()
//        balls[12].position = BallVector(0.5 * diameter, -dz).vector()
//        balls[13].position = BallVector(0, 2 * dz).vector()
//        balls[14].position = BallVector(1.5 * diameter, 1 * dz).vector()
//        balls[15].position = BallVector(-diameter, 0).vector()
        
    }
    
    static func degToRad(_ deg: Int) -> CGFloat {
        return CGFloat(Double(deg / 180) * Double.pi)
    }
}
