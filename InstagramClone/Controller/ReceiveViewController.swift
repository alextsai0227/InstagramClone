//
//  ReceiveViewController.swift
//  BLNewTest
//
//  Created by 司辰  赵 on 2018/10/19.
//  Copyright © 2018年 司辰  赵. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ReceiveViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    
    
    @IBOutlet weak var ReceivedImage: UIImageView!
    override func viewDidLoad() {
        self.setupConnectivity()
        super.viewDidLoad()
        
        let mcBrowser = MCBrowserViewController(serviceType: "bt-wifi", session: self.mcSession)
        mcBrowser.delegate = self
        self.present(mcBrowser, animated: true, completion: nil)
        // Do any additional setup after loading the view.
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
        do{
            DispatchQueue.main.async {
                let receivedImageURL =  NSString(data:data ,encoding: String.Encoding.utf8.rawValue)
                print(receivedImageURL)
                self.ReceivedImage.sd_setImage(with: URL(string: receivedImageURL as! String), placeholderImage: UIImage(named: "placeholder"))
            }
            
        }catch{
            print("unable to process the received data")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
