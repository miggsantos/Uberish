//
//  UpdateService.swift
//  Uberish
//
//  Created by Miguel Santos on 11/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

class UpdateService {

    static let instance = UpdateService()
    
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
    
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for user in snapshot {
                    if user.key == FIRAuth.auth()?.currentUser?.uid {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                        //return;
                    }
                }
            }
        })  
    }
    
    func updateDriverLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for driver in snapshot {
                    if driver.key == FIRAuth.auth()?.currentUser?.uid {
                        if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                            DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
                        }
                        //return;
                    }
                }
            }
        })
    }
    
    
}
