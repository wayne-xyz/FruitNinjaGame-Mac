//
//  ConnectManager.swift
//  FruitNinjaPhone
//
//  Created by RongWei Ji on 10/30/23.
//

import Foundation
import MultipeerConnectivity

protocol ConnectManagerDelegate: AnyObject {
    func didReceiveMessage(_ message: String, from peer: MCPeerID)
    func didChangeConnectionState(peer: MCPeerID, isConnected: Bool)
}

class ConnectManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    private let serviceType = "MacGameApp"
    private let myPeerId: MCPeerID
    var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    
    weak var delegate: ConnectManagerDelegate?
    
    static let shared = ConnectManager()
    
    private override init() {
        myPeerId = MCPeerID(displayName: "MacGameHost")
        super.init()
        
        session = MCSession(peer: myPeerId)
        session?.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        advertiser?.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser?.delegate = self
    }
    
    func start() {
        advertiser?.startAdvertisingPeer()
        browser?.startBrowsingForPeers()
    }
    
    func send(message: String, to peers: [MCPeerID]) {
        guard let session = session else { return }
        if !session.connectedPeers.isEmpty {
            do {
                try session.send(message.data(using: .utf8)!, toPeers: peers, with: .reliable)
            } catch {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: MCSessionDelegate
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let isConnected = (state == .connected)
        delegate?.didChangeConnectionState(peer: peerID, isConnected: isConnected)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(data: data, encoding: .utf8) {
            delegate?.didReceiveMessage(message, from: peerID)
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Handle resource transfer progress if needed
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Handle resource transfer completion if needed
    }
    
    // MARK: MCNearbyServiceAdvertiserDelegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    // MARK: MCNearbyServiceBrowserDelegate
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
       // part for mac
       
        if peerID.displayName=="iosGameApp"{
            browser.invitePeer(peerID, to: session!, withContext: nil, timeout: 30)
            print("Mac app is connecting:\(peerID)")  // print the id
        }
    
        

    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        // Handle lost peers if needed
    }
}


