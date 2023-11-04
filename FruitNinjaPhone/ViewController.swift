//
//  ViewController.swift
//  FruitNinjaPhone
//
//  Created by RongWei Ji on 10/23/23.
//
// this is main viewcontroller to show game
// ios - advertising          - done- accept invite- done
// mac - browsing(discovering)- done- invite       - done

// setting in xcode:
//Enable App Sandbox:

import Cocoa
import SpriteKit
import MultipeerConnectivity

class ViewController: NSViewController , ConnectManagerDelegate {
    
    func didReceiveMessage(_ message: String, from peer: MCPeerID) {
        if(message=="Start"){
            print("macconnect recived:\(message)")
            DispatchQueue.main.async{
                self.loadGameScence()
                self.promptText.isHidden=true
            }
        }
    }
    
    func didChangeConnectionState(peer: MCPeerID, isConnected: Bool) {
        
        if isConnected{
            DispatchQueue.main.async {
                self.promptText.stringValue="Connected, start on your phone, Go Ninja!"
            }
        }else{
            print("lost connecting")
        }
       
    }
    
    @IBOutlet weak var promptText: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ConnectManager.shared.delegate = self
        ConnectManager.shared.start()
       
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

