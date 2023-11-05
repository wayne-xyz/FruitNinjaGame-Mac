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

class ViewController: NSViewController , ConnectManager2Delegate {
    func websocketDidConnect() {
        changeConnectState(isC: true)
    }
    
    func websocketDidDisconnect(error: Error?) {
        changeConnectState(isC:false)
    }
    
    func websocketDidReceiveMessage(text: String) {
        receiveMessage(mes: text)
    }
    
    

    
    func receiveMessage(mes:String){
        if(mes=="Start"){
            print("macconnect recived:\(mes)")
            DispatchQueue.main.async{
                self.loadGameScence()
                self.promptText.isHidden=true
            }
        }
    }
    
    func changeConnectState(isC:Bool){
        if isC{
            DispatchQueue.main.async {
                self.promptText.stringValue="Connected, start on your phone, Go Ninja!"
            }
        }else{
            print("lost connecting")
        }
    }
    

    
    @IBOutlet weak var promptText: NSTextField!
    
    var webSocketManager: ConnectManager2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let serverURL = URL(string: "ws://127.0.0.1:8888/websocket")!
        // Set up the ConnectManager2 with a URL
        ConnectManager2.shared.configure(with: serverURL)

        // Connect to the WebSocket server
        ConnectManager2.shared.delegate=self
        ConnectManager2.shared.connect()
        

        // Send a message
        ConnectManager2.shared.send(message: "MacBook online")

        
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

