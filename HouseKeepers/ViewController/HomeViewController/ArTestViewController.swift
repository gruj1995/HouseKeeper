//
//  ArTestViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/14.
//

import UIKit
import ARCoreLocation
import CoreLocation
import ARKit


class ArTestViewController: UIViewController {

    @IBOutlet weak var arview: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let landmarker = ARLandmarker(view: ARSKView(), scene: InteractiveScene(), locationManager: CLLocationManager())
        landmarker.view.frame = self.view.bounds
        landmarker.scene.size = self.view.bounds.size
        self.view.addSubview(landmarker.view)
        
        let landmarkLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75, height: 20))
        landmarkLabel.text = "Statue of Liberty"
        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 40.689234, longitude: -74.044524), altitude: 30, horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: Date())
        landmarker.addLandmark(view: landmarkLabel, at: location, completion: nil)
        
        landmarker.delegate = self
        
        
        landmarker.overlappingLandmarksStrategy = .showAll
//        landmarker.overlappingLandmarksStrategy = .showNearest
//        landmarker.overlappingLandmarksStrategy = .showFarthest
//        landmarker.overlappingLandmarksStrategy = .custom(callback: { (overlappingLandmarkGroups, notOverlappingLandmarks) in
            // Check overlapping groups and react accordingly
//        })
    }
    



}


extension ArTestViewController: ARLandmarkerDelegate {
    func landmarkDisplayer(_ landmarkDisplayer: ARLandmarker, didFailWithError error: Error) {
        print("---------")
    }
    
    func landmarkDisplayerIsReady() {
        print("---------")
    }
    
   
}
