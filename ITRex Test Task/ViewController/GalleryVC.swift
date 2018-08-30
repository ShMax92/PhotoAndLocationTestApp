//
//  GalleryVC.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 29.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "imageCell"

class GalleryVC: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let locationManager = CLLocationManager()
    var photos = [MyPhoto]()
    
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
        takePhoto()
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
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            locationManager.startUpdatingLocation()
            let photoData = UIImagePNGRepresentation(photo)!
            let date = Date()
            let latitude = locationManager.location!.coordinate.latitude
            let longitude = locationManager.location!.coordinate.longitude
            let location = Location(latitude: latitude, longitude: longitude)
            
            let myPhoto = MyPhoto(photo: photoData, date: date, location: location)
            photos.append(myPhoto)
            
            picker.dismiss(animated: true) {
                self.locationManager.stopUpdatingLocation()
                self.collectionView?.reloadData()
                self.storeData()
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
            let photo = UIImage(data: photos[indexPath.row].photo)
            cell.photoPreview.image = photo
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
        let detailsAction = UIAlertAction(title: "Details", style: .default) { (_) in
            if let detailsVC = Storyboard.instantiateViewController(withIdentifier: "DetailsVC") as? DetailsVC {
                detailsVC.myPhoto = self.photos[indexPath.row]
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
        
        let mapAction = UIAlertAction(title: "Map", style: .default) { (_) in
            if let mapVC = Storyboard.instantiateViewController(withIdentifier: "MapVC") as? MapVC {
                mapVC.myPhoto = self.photos[indexPath.row]
                self.navigationController?.pushViewController(mapVC, animated: true)
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            self.photos.remove(at: indexPath.row)
            self.storeData()
            self.collectionView?.reloadData()
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
