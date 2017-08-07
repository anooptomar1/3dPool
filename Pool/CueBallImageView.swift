//
//  CueBallImageView.swift
//  Pool
//
//  Created by Kay Ven on 8/7/17.
//  Copyright © 2017 anon. All rights reserved.
//

import Cocoa

class CueBallImageView: NSImageView {
    
    override func mouseDown(with event: NSEvent) {
        
        let winLoc = event.locationInWindow
        let loc = self.convert(winLoc, from: nil)
        
        let app = NSApplication.shared().delegate as! AppDelegate
        app.cueBallClicked(loc, winLoc)
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let winLoc = event.locationInWindow
        let loc = self.convert(winLoc, from: nil)
        
        let app = NSApplication.shared().delegate as! AppDelegate
        app.cueBallClicked(loc, winLoc)
    }
}
