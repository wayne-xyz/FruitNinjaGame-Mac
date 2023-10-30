//
//  ViewController.swift
//  FruitNinjaPhone
//
//  Created by RongWei Ji on 10/23/23.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        // Do any additional setup after loading the view.
    }
    
    
    // set the windows as full as the screen, limit it any moving
    override func viewDidAppear() {
        if let screen = NSScreen.main,
                   let window = view.window {
                    let screenFrame = screen.visibleFrame
                    window.setFrame(screenFrame, display: true, animate: true)
        }
        if let window = self.view.window {
            window.styleMask.remove(.resizable)
        }
    }
    
    // load the game scence
    func loadGameScence(){
        let scene=FruitGameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS=true
        skView.showsNodeCount=true
        skView.ignoresSiblingOrder=true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    
    
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

