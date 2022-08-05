//
//  ViewController.swift
//  Phone Battery Percentage
//
//  Created by Andrej Vujić on 4. 8. 2022..
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let dataFromWatch = message["requestFromWatch"] as? String {
            print(dataFromWatch)
            if dataFromWatch == "batteryLevelRequest" {
                sendBatteryLevelToWatch()
            }
        }
    }
    
    var session: WCSession?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupWCSession()
        setupBatteryLevelMonitoring()
    }
    
    func setupWCSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func setupBatteryLevelMonitoring() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var deviceName: String { UIDevice.current.name }
    
    func sendBatteryLevelToWatch() {
        if let s = self.session, s.isReachable {
            let dataToWatch: [String: Any] =  ["batteryLevel": "\(batteryLevel * 100)%", "deviceName": deviceName,
            ]
            s.sendMessage(dataToWatch, replyHandler: nil, errorHandler: nil)
        }
    }
    
}

