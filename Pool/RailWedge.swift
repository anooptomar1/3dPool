//
//  RailWedge.swift
//  Pool
//
//  Created by Kay Ven on 8/6/17.
//  Copyright © 2017 anon. All rights reserved.
//

import Foundation
import SceneKit

class RailWedge {
    
    static func getVerticalWedge(_ center: SCNVector3, _ width: CGFloat, _ height: CGFloat, _ length: CGFloat, _ nearSide: Bool) -> SCNNode {
        
        let flip: Bool = center.x < 0
        
        let p0x = flip ? center.x + width / 2 : center.x - width / 2
        let p0y = center.y + height / 2
        let p0z = center.z
        
        let p0 = SCNVector3(x: p0x, y: p0y, z: p0z)
        
        let p1x = flip ? center.x - width / 2 : center.x + width / 2
        let p1y = p0y
        let p1z = p0z
        
        let p1 = SCNVector3(x: p1x, y: p1y, z: p1z)
        
        let p2x = p1x
        let p2y = p1y
        let p2z = nearSide ? p1z + length : p1z - length
        
        let p2 = SCNVector3(x: p2x, y: p2y, z: p2z)
        
        let p3 = SCNVector3(x: p0x, y: p0y - height, z: p0z)
        
        let p4 = SCNVector3(x: p1x, y: p1y - height, z: p1z)
        
        let p5 = SCNVector3(x: p2x, y: p2y - height, z: p2z)
        
        let positions: [SCNVector3] = [p0, p1, p2, p3, p4, p5]
        
//        let positions: [SCNVector3] = [p0, p1, p2, p3, p4, p5, p0, p1, p2, p3, p4, p5, p0, p1, p2, p3, p4, p5]
        
        let normals: [SCNVector3] = [SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1),
                                     
                                     SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1),
                                     
                                     SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1),
                                     
                                     SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1),
                                     
                                     SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1),
                                     
                                     SCNVector3Make( 0, 1, 0),
                                     SCNVector3Make( -1, 0, 0),
                                     SCNVector3Make( 0, 0, -1)]
        
//        SCNGeometrySource *vertexSource =
//            [SCNGeometrySource geometrySourceWithVertices:positions
//                count:24];
//        SCNGeometrySource *normalSource =
//            [SCNGeometrySource geometrySourceWithNormals:normals
//                count:24];
//        
//        SCNGeometry *geometry =
//            [SCNGeometry geometryWithSources:@[vertexSource, normalSource]
//                elements:@[element]];
        
        let vSource = SCNGeometrySource(vertices: positions, count: 6)
//        let nSource = SCNGeometrySource(normals: normals)
        
        let indices: [UInt16] = [
            
            0, 1, 2,
            0, 3, 2,
            5, 2, 3
        ]
        
        let iData: NSData = NSData(bytes: indices, length: MemoryLayout.size(ofValue: indices[0]) * indices.count)
        
//        SCNGeometryElement *element =
//            [SCNGeometryElement geometryElementWithData:indexData
//                primitiveType:SCNGeometryPrimitiveTypeTriangles
//                primitiveCount:12
//                bytesPerIndex:sizeof(int)];
        
        let element = SCNGeometryElement(data: iData as Data?, primitiveType: SCNGeometryPrimitiveType.triangles, primitiveCount: 3, bytesPerIndex: MemoryLayout<UInt16>.size)
        
        let geom = SCNGeometry(sources: [vSource], elements: [element])
        
        let node = SCNNode(geometry: geom)
        
        node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        return node
    }
    
    static func getHorizontalWedge(_ center: SCNVector3, _ width: CGFloat, _ height: CGFloat, _ length: CGFloat, _ leftSide: Bool) -> SCNNode {
        
        let flip: Bool = center.z < 0
        
        let p0x = center.x
        let p0y = center.y + height / 2
        let p0z = flip ? center.z + length / 2 : center.z - length / 2
        
        let p0 = SCNVector3(x: p0x, y: p0y, z: p0z)
        
        let p1x = p0x
        let p1y = p0y
        let p1z = flip ? center.z - length / 2 : center.z + length / 2
        
        let p1 = SCNVector3(x: p1x, y: p1y, z: p1z)
        
        let p2x = leftSide ? p1x - width : p1x + width
        let p2y = p1y
        let p2z = p1z
        
        let p2 = SCNVector3(x: p2x, y: p2y, z: p2z)
        
        let p3 = SCNVector3(x: p0x, y: p0y - height, z: p0z)
        
        let p4 = SCNVector3(x: p1x, y: p1y - height, z: p1z)
        
        let p5 = SCNVector3(x: p2x, y: p2y - height, z: p2z)
        
        let positions: [SCNVector3] = [p0, p1, p2, p3, p4, p5]
        
        let vSource = SCNGeometrySource(vertices: positions, count: 6)
        
        let indices: [UInt16] = [
            
            0, 1, 2,
            0, 3, 2,
            5, 2, 3
        ]
        
        let iData: NSData = NSData(bytes: indices, length: MemoryLayout.size(ofValue: indices[0]) * indices.count)
        
        let element = SCNGeometryElement(data: iData as Data?, primitiveType: SCNGeometryPrimitiveType.triangles, primitiveCount: 3, bytesPerIndex: MemoryLayout<UInt16>.size)
        
        let geom = SCNGeometry(sources: [vSource], elements: [element])
        
        let node = SCNNode(geometry: geom)
        
        node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        return node
    }
}
