//
//  MyMarker.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/18.
//

import Foundation
import GoogleMapsUtils



/// 產生地圖上的標記
class MyMarker: GMSMarker {
    
    let markerData: MarkerData // Raw data from server
    var address:String?
    
    init(markerData: MarkerData) {
        self.markerData = markerData
        super.init()
        self.title = markerData.title
        self.position = markerData.position
        self.address = markerData.address

    }
    

}
