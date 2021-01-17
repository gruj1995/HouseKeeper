//
//  ClusterItem.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/18.
//

import UIKit
import GoogleMapsUtils


/// 產生地圖上叢集項目
class ClusterItem: NSObject, GMUClusterItem {
    let markerData: MarkerData // Raw data from server
    let position: CLLocationCoordinate2D

    

    init(markerData: MarkerData) {
        self.markerData = markerData
        self.position = markerData.position
    }
}
