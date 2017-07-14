//
//  RoundMapView.swift
//  Uberish
//
//  Created by Miguel Santos on 13/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit
import MapKit

class RoundMapView: MKMapView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 10
    }
    
}
