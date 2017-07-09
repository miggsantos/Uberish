//
//  LoginVC.swift
//  Uberish
//
//  Created by Miguel Santos on 09/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeybord()
        
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


}
