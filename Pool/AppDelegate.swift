//
//  AppDelegate.swift
//  Pool
//
//  Created by Kay Ven on 8/4/17.
//  Copyright (c) 2017 anon. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    private var balls: Balls = Balls.instance()
    
    @IBOutlet weak var crosshair: NSImageView!
    private let cueBallViewRadius: CGFloat = 45
    private let cueBallViewRadiusSquared: CGFloat = 2025
    
    var cueBallStrikePoint: NSPoint = NSPoint(x: 0, y: 0)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        balls.rack()
    }
    
    func cueBallClicked(_ loc: NSPoint, _ absLoc: NSPoint) {
        
        let ox = absLoc.x - crosshair.frame.width / 2
        let oy = absLoc.y - crosshair.frame.height / 2
        
        let x = loc.x - 50
        let y = loc.y - 50
        
        let ax = abs(x)
        let ay = abs(y)
        
        let my = sqrt(cueBallViewRadiusSquared - (ax * ax))
        
        if (ay <= my) {
            crosshair.frame.origin = NSPoint(x: ox, y: oy)
            cueBallStrikePoint = NSPoint(x: x / 90, y: y / 90)
        }
    }
}
