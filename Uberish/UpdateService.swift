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
    
    func observeTrips(handler: @escaping(_ coordinateDict: Dictionary<String, AnyObject>?) -> Void) {
        DataService.instance.REF_TRIPS.observe(.value, with: { (snapshot) in
            if let tripSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for trip in tripSnapshot {
                    if trip.hasChild("passengerKey") && trip.hasChild("tripIsAccepted") {
                        if let tripDict = trip.value as? Dictionary<String, AnyObject> {
                            handler(tripDict)
                        }

                    }
                }
            }
            
        })
    }
    
    
    func updateTripsWithCoordinatesUponRequest() {
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for user in snapshot {
                    if user.key == FIRAuth.auth()?.currentUser?.uid {
                        if !user.hasChild("userIsDriver") {
                            if let userDict = user.value as? Dictionary<String, AnyObject> {
                                let pickupArray = userDict["coordinate"] as! NSArray
                                let destinationArray = userDict["tripCoordinate"] as! NSArray
                                
                                DataService.instance.REF_TRIPS.child(user.key).updateChildValues(["pickupCoordinate": [pickupArray[0], pickupArray[1]],
                                                                                                  "destinationCoordinate": [destinationArray[0], destinationArray[1]],
                                                                                                  "passengerKey": user.key,
                                                                                                  "tripIsAccepted": false ])
                                return;

                            }
                        }
                        
                    }
                }
            }
        })
    }
    
    
    func acceptTrip(withPassenger passengerKey: String, forDriverKey driverKey: String) {
        
        DataService.instance.REF_TRIPS.child(passengerKey).updateChildValues(["driverKey": driverKey, "tripIsAccepted": true])
        DataService.instance.REF_DRIVERS.child(driverKey).updateChildValues(["driverIsOnTrip": true])
        
    }
    
    func cancelTrip(withPassengerKey passengerKey: String, forDriverKey driverKey: String) {
        DataService.instance.REF_TRIPS.child(passengerKey).removeValue()
        DataService.instance.REF_USERS.child(passengerKey).child("tripCoordinate").removeValue()
        DataService.instance.REF_DRIVERS.child(driverKey).updateChildValues(["driverIsOnTrip": false])
        
    }
    
    
}
