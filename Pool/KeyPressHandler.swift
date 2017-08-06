//
//  KeyPressHandler.swift
//  Pool
//
//  Created by Kay Ven on 8/5/17.
//  Copyright © 2017 anon. All rights reserved.
//

import Foundation
import SceneKit

class KeyPressHandler {
    
    static func handle(_ event: NSEvent, _ cameraNode: SCNNode) {
        print(event.keyCode)
        
        let x = cameraNode.position.x
        let y = cameraNode.position.y
        let z = cameraNode.position.z
        
        switch event.keyCode {
        case 123: // Left
            let nx = x - 2
            cameraNode.position = SCNVector3(x: nx, y: y, z: z)
        case 124: // Right
            let nx = x + 2
            cameraNode.position = SCNVector3(x: nx, y: y, z: z)
        case 126: // Up
            let nz = z - 2
            cameraNode.position = SCNVector3(x: x, y: y, z: nz)
        case 125: // Down
            let nz = z + 2
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
        default: print("no-op")
        }
    }
}
