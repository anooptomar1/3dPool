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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        balls.rack()
    }
}
