//
//  LandmarkMarker.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/2.
//

import GoogleMaps

/// 產生地圖上的標記
class LandmarkMarker: GMSMarker {
    
    let landmarkData: LandMarkModel // Raw data from server

    init(landmarkData: LandMarkModel) {
        self.landmarkData = landmarkData
        super.init()
        self.title = landmarkData.name
        self.position = landmarkData.position
        
        self.icon = setIcon(type: landmarkData.type)
//        self.address = landmarkData.address
        
       
        
    }
    
    static var temple : UIImage =  UIImage(named: "landmark_temple")!
    static var baseStation : UIImage =  UIImage(named: "landmark_baseStation")!
    static var funeral : UIImage =  UIImage(named: "landmark_funeral")!
    static var subStation : UIImage =  UIImage(named: "landmark_subStation")!
    static var factory : UIImage =  UIImage(named: "landmark_factory")!
    static var gasStation : UIImage =  UIImage(named: "landmark_gasStation")!
    static var hauntedHouse : UIImage =  UIImage(named: "landmark_hauntedHouse")!
    
    
    func setIcon(type: String) -> UIImage?{
        switch type {
        case "trainStation":
            return UIImage(named: "landmark_trainStation")!
        case "hospital":
            return UIImage(named: "landmark_hospital")!
        case "mrt":
            return UIImage(named: "landmark_mrt")!
        case "policeStation":
            return UIImage(named: "landmark_police")!
        case "funeral":
            return LandmarkMarker.funeral
        case "factory":
            return LandmarkMarker.factory
        case "temple":
            return LandmarkMarker.temple
        case "gasStation":
            return LandmarkMarker.gasStation
        case "baseStation":
            return LandmarkMarker.baseStation
        case "substation":
            return LandmarkMarker.subStation
        case "hauntedHouse":
            return LandmarkMarker.hauntedHouse
        case "carPark":
            return UIImage(named: "landmark_carPark")!
            
        default:
            return nil
        }
    }
    
//    func setIcon(type: String) -> UIImage?{
//        switch type {
//        case "trainStation":
//            return UIImage(named: "landmark_trainStation")!
//        case "hospital":
//            return UIImage(named: "landmark_hospital")!
//        case "mrt":
//            return UIImage(named: "landmark_mrt")!
//        case "policeStation":
//            return UIImage(named: "landmark_police")!
//        case "funeral":
//            return UIImage(named: "landmark_funeral")!
//        case "factory":
//            return UIImage(named: "landmark_factory")!
//        case "temple":
//            return UIImage(named: "landmark_temple")!
//        case "gasStation":
//            return UIImage(named: "landmark_gasStation")!
//        case "baseStation":
//            return UIImage(named: "landmark_baseStation")!
//        case "substation":
//            return UIImage(named: "landmark_subStation")!
//        case "hauntedHouse":
//            return UIImage(named: "landmark_hauntedHouse")!
//        case "carPark":
//            return UIImage(named: "landmark_carPark")!
//
//        default:
//            return nil
//        }
//    }
}
