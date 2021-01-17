//
//  PanoramaViewController.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/20.
//

import UIKit
import GoogleMaps


class PanoramaViewController: UIViewController {

    @IBOutlet weak var panoramaView: GMSPanoramaView!
    override func viewDidLoad() {
        super.viewDidLoad()
        panoramaView.delegate = self
        panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: 37.3317134, longitude: -122.0307466))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2){
            self.panoramaView.animate(to: GMSPanoramaCamera(heading: 90, pitch: 0, zoom: 1), animationDuration: 2)
        }
    }
 

}

//擷取當街景改變時的任何事觸發
    extension PanoramaViewController: GMSPanoramaViewDelegate {
        func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
            print(error.localizedDescription)
        }
    }
