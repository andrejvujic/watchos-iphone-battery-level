//
//  InterfaceController.swift
//  Phone Battery Percentage WatchKit Extension
//
//  Created by Andrej Vujić on 4. 8. 2022..
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let deviceName = message["deviceName"] as? String {
            self.deviceNameLabel.setText(deviceName)
        }
        
        if let batteryLevel = message["batteryLevel"] as? String {
            self.batteryLevelLabel.setText(batteryLevel)
        }
    }
    

    @IBOutlet weak var deviceNameLabel: WKInterfaceLabel!
    @IBOutlet weak var batteryLevelLabel: WKInterfaceLabel!
    
    @IBAction func refreshButtonTapped() {
        requestBatteryLevelFromPhone();
    }
    
    var session = WCSession.default
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        session.delegate = self
        session.activate()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        requestBatteryLevelFromPhone()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    func requestBatteryLevelFromPhone() {
        deviceNameLabel.setText("iPhone")
        batteryLevelLabel.setText("...")

        let dataToPhone: [String: Any] = ["requestFromWatch": "batteryLevelRequest" as Any]
        session.sendMessage(dataToPhone, replyHandler: nil, errorHandler: nil)
    }
}
