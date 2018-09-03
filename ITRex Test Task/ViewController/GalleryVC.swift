//
//  GalleryVC.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 29.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation
import AVKit

private let reuseIdentifier = "imageCell"

class GalleryVC: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photos = PhotoStorage.loadPhotos(){
            self.photos = photos
            self.collectionView?.reloadData()
        }
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        let locationStatus = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        
        if locationStatus && cameraStatus {
            takePhoto()
        } else {
            let noAccessAlert = UIAlertController()
            let getAccessAction = UIAlertAction(title: "Access needed", style: .default) {(_) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url as URL) { (_) in
                    }
                }
            }
            noAccessAlert.addAction(getAccessAction)
            self.present(noAccessAlert, animated: true, completion: nil)
        }
    }
    
    private func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let newPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage {
            locationManager.startUpdatingLocation()
            if let photoImage = newPhoto.fixedOrientation() {
                if let photoData = UIImagePNGRepresentation(photoImage) {
                    let photoDate = Date()
                    if let location = locationManager.location {
                        let latitude = location.coordinate.latitude
                        let longitude = location.coordinate.longitude
                        let photoLocation = Location(latitude: latitude, longitude: longitude)
                        let photo = Photo(photoData: photoData, photoDate: photoDate, photoLocation: photoLocation)
                        photos.append(photo)
                        
                        picker.dismiss(animated: true) {
                            self.locationManager.stopUpdatingLocation()
                            self.storeData()
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    private func storeData() {
        DispatchQueue.global().async {
            PhotoStorage.storePhotos(photos: self.photos)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
}

extension GalleryVC: UICollectionViewDelegateFlowLayout {
    
    //MARK: - UICollectionVC Delegate & DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GalleryCell {
            if let photoData = photos[indexPath.row].photoData {
                let photoImage = UIImage(data: photoData)
                cell.photoPreview.image = photoImage
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    //adding alerts
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        let alert = UIAlertController(title: "Actions:", message: nil, preferredStyle: .actionSheet)
        //details
        let detailsAction = UIAlertAction(title: "Details", style: .default) { [weak self] (_) in
            if let detailsVC = Storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
                detailsVC.photo = self?.photos[indexPath.row]
                self?.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
        
        let mapAction = UIAlertAction(title: "Map", style: .default) { [weak self] (_) in
            if let mapVC = Storyboard.instantiateViewController(withIdentifier: "MapVC") as? MapVC {
                mapVC.photo = self?.photos[indexPath.row]
                self?.navigationController?.pushViewController(mapVC, animated: true)
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
            self?.photos.remove(at: indexPath.row)
            self?.storeData()
            self?.collectionView?.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(detailsAction)
        alert.addAction(mapAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.maxX / 3) - 3
        return CGSize(width: width, height: width)
    }
}
