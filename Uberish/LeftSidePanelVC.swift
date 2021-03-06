//
//  LeftSidePanelVC.swift
//  Uberish
//
//  Created by Miguel Santos on 09/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()

    let currentUserId = FIRAuth.auth()?.currentUser?.uid
    
    @IBOutlet weak var userEmaiLbl: UILabel!
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var logInOutBtn: UIButton!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var pickupModeLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isOn = false
        pickupModeSwitch.isHidden = true
        pickupModeLbl.isHidden = true
        
        observePassengerAndDrivers()
        
        if FIRAuth.auth()?.currentUser == nil {
            userEmaiLbl.text = ""
            userAccountTypeLbl.text = ""
            userImageView.isHidden = true
            logInOutBtn.setTitle(MSG_SIGN_UP_SIGN_IN, for: .normal)
        } else {
            userEmaiLbl.text = FIRAuth.auth()?.currentUser?.email
            userAccountTypeLbl.text = ""
            userImageView.isHidden = false
            logInOutBtn.setTitle(MSG_SIGN_OUT, for: .normal)
        }
        
    }
    
    func observePassengerAndDrivers() {
    
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if snap.key == FIRAuth.auth()?.currentUser?.uid {
                        self.userAccountTypeLbl.text = ACCOUNT_TYPE_PASSENGER
                        return;
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if snap.key == FIRAuth.auth()?.currentUser?.uid {
                        self.userAccountTypeLbl.text = ACCOUNT_TYPE_DRIVER
                        self.pickupModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: ACCOUNT_PICKUP_MODE_ENABLED).value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                        
                        break;
                    }
                }
            }
        })
    
    }

    @IBAction func switchWasToggled(_ sender: Any) {
    
        if pickupModeSwitch.isOn {
            pickupModeLbl.text = MSG_PICKUP_MODE_ENABLED
            appDelegate.MenuContainerVC.toogleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: true])
        } else {
            pickupModeLbl.text = MSG_PICKUP_MODE_DISABLE
            appDelegate.MenuContainerVC.toogleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: false])
        }
        
    }
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        
        if FIRAuth.auth()?.currentUser == nil {
        
            let storyboard = UIStoryboard(name: MAIN_STORYBOARD, bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: VC_LOGIN) as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            
            do {
                try FIRAuth.auth()?.signOut()
                
                userEmaiLbl.text = ""
                userAccountTypeLbl.text = ""
                userImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true
                logInOutBtn.setTitle(MSG_SIGN_UP_SIGN_IN, for: .normal)
                
            } catch (let error) {
                print(error)
            }
        }
    }

}
