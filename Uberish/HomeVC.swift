//
//  ViewController.swift
//  Uberish
//
//  Created by Miguel Santos on 08/07/2017.
//  Copyright © 2017 Miguel Santos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RevealingSplashView

class HomeVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionBtn: RoundShadowButton!
    
    var delegate: CenterVCDelegate?
    var manager: CLLocationManager?
    
    var regionRadius: CLLocationDistance = 1000
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        checkLocationAuthStatus()
        
        mapView.delegate = self
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        
        centerMapOnUserLocation()
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        
        revealingSplashView.heartAttack = true
        
    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            

            manager?.startUpdatingLocation()
            
        } else {
            manager?.requestAlwaysAuthorization()
        }
    
    }
    
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func actionBtnWasPressed(_ sender: Any) {
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
    }

    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
    
        centerMapOnUserLocation()
    }
    
    
    @IBAction func menuBtnWasPressed(_ sender: Any) {
        
        delegate?.toogleLeftPanel()
        
    }
}

extension HomeVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthStatus()
        if status == .authorizedAlways {

            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
}

