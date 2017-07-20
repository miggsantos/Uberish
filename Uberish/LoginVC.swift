//
//  LoginVC.swift
//  Uberish
//
//  Created by Miguel Santos on 09/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {

    @IBOutlet weak var emailField: RoundedCornerTextField!
    @IBOutlet weak var passwordField: RoundedCornerTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authBtn: RoundShadowButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeybord()
        
        emailField.delegate = self
        passwordField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
    }

    func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func authBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        if let user = user {
                            
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                // passenger
                                let userData = ["provider": user.providerID] as [String:Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            }  else {
                                // driver
                                let userData = ["provider": user.providerID, USER_IS_DRIVER: true, ACCOUNT_PICKUP_MODE_ENABLED: false, DRIVER_IS_ON_TRIP: false] as [String:Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        
                        //print("Email user authenticated successfully with Firebase")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // User is not logged in
                        
                        if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                            switch errorCode {

                            case .errorCodeWrongPassword:
                                self.showAlert(ERROR_MSG_WRONG_PASSWORD)

                            default:
                                self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                                
                            }
                        }
                        
                        
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    case .errorCodeInvalidEmail:
                                        self.showAlert(ERROR_MSG_INVALID_EMAIL)
                                    case .errorCodeEmailAlreadyInUse:
                                        self.showAlert(ERROR_MSG_EMAIL_ALREADY_IN_USE)
                                    case .errorCodeWeakPassword:
                                        self.showAlert(ERROR_MSG_WEAK_PASSWORD)
                                    default:
                                        self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                                        
                                    }
                                }
                            } else {
                                if let user = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String:Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID, USER_IS_DRIVER: true, ACCOUNT_PICKUP_MODE_ENABLED: false, DRIVER_IS_ON_TRIP: false] as [String:Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                //print("Successfully created a new user with Firebase")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                        
                    }
                    
                })
            
            }
        }
    }

}
