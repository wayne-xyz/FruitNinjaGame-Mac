//
//  ViewController.swift
//  FruitNinjaPhone
//
//  Created by RongWei Ji on 10/23/23.
//
// this is main viewcontroller to show game

import Cocoa
import SpriteKit
import MultipeerConnectivity

class ViewController: NSViewController , ConnectManagerDelegate {
    func didReceiveMessage(_ message: String, from peer: MCPeerID) {
        print("macconnect recived:\(message)")
    }
    
    func didChangeConnectionState(peer: MCPeerID, isConnected: Bool) {
        print("macconnect statues:\(isConnected)")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
        //test for send a message
        
        ConnectManager.shared.delegate = self
        ConnectManager.shared.start()
        if let session = ConnectManager.shared.session, !session.connectedPeers.isEmpty {
            ConnectManager.shared.send(message: "hello world, I am machost", to: session.connectedPeers)
        }
       
       
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
        loadGameScence()
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
    
    func segueToSettingVC(){
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            
    }
    
    
    
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

