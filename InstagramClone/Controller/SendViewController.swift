//
//  SendViewController.swift
//  BLNewTest
//
//  Created by 司辰  赵 on 2018/10/19.
//  Copyright © 2018年 司辰  赵. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import FirebaseDatabase
import FirebaseAuth
import Firebase
import SDWebImage

class SendViewController: UIViewController, MCSessionDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAssistant: MCAdvertiserAssistant!
    
    var url: String?
    
    @IBOutlet weak var Image: UIImageView!
    
    override func viewDidLoad() {
        self.setupConnectivity()
        super.viewDidLoad()
        self.Image.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "placeholder"))
        self.mcAssistant = MCAdvertiserAssistant(serviceType: "bt-wifi", discoveryInfo: nil, session: self.mcSession)
        self.mcAssistant.start()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.state == .ended){
            if (sender.direction == .right) {
                print("Swipe Right")
                if mcSession.connectedPeers.count > 0{
                    let a = self.url
                    let toSendData = a?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    do{
                        try mcSession.send(toSendData!, toPeers: mcSession.connectedPeers, with: .reliable)
                    }catch{
                        print("cannot send")
                    }
                }
                else{
                    print("You are not connect to anyone.")
                }
            }
        }
    }
    
    func setupConnectivity(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected:\(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting:\(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected:\(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
}
