//
//  BallPosition.swift
//  Pool
//
//  Created by Kay Ven on 8/5/17.
//  Copyright © 2017 anon. All rights reserved.
//

import Foundation
import SceneKit

class BallVector {

    private var _vector: SCNVector3
    
    init(_ x: CGFloat, _ z: CGFloat) {
        self._vector = SCNVector3(x: x, y: 0.5, z: z)
    }
    
    func vector() -> SCNVector3 {
        return _vector
    }
}
