//
//  ViewController.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 28.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class PermissionVC: UIViewController {

    @IBOutlet weak var permissionLabel: UILabel!
    @IBOutlet weak var cameraPermissionButton: UIButton!
    @IBOutlet weak var locationPermitionButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    private let locationManager = CLLocationManager()
    private var locationAccessGranted: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    private var cameraAccessGranted: Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAccess()
    }
    
    @IBAction func getAccessToLocation(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            let locationStatus = CLLocationManager.authorizationStatus()
            if locationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            else if locationStatus == .denied {
                openSettings()
            }
        }
        locationPermitionButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func getAccessToCamera(_ sender: Any) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video) { (_) in
            }
        } else if cameraStatus == .denied {
            openSettings()
        }
        cameraPermissionButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func goNext(_ sender: Any) {
        if locationAccessGranted && cameraAccessGranted {
            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
            let galleryVC = Storyboard.instantiateViewController(withIdentifier: "navController")
            present(galleryVC, animated: true, completion: nil)
        } else {
            checkAccess()
        }
    }
    
    //make button title red when no access
    private func checkAccess() {
        if !locationAccessGranted {
            locationPermitionButton.setTitleColor(UIColor.red, for: .normal)
        }
        if !cameraAccessGranted {
            cameraPermissionButton.setTitleColor(UIColor.red, for: .normal)
        }
    }
    
    //open settings to get access
    private func openSettings() {
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url as URL) { (_) in
            }
        }
    }
}

