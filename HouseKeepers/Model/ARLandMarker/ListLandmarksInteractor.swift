//
//  ListLandmarksInteractor.swift
//  ARCoreLocationExample
//
//  Created by Skyler Smith on 2019-01-02.
//  Copyright (c) 2019 Freshworks Studio Inc.. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate typealias Landmark = ListLandmarks.FetchLandmarks.Response.Landmark

protocol ListLandmarksPresentationPreparer {
    func presentLandmarks(response: ListLandmarks.FetchLandmarks.Response)
}



protocol  ListLandmarksInteractorDataSource : AnyObject {
    func getlandmarkList(_ ListLandmarksInteractor : ListLandmarksInteractor) -> [String]
}



class ListLandmarksInteractor {
    
    weak var dataSource :  ListLandmarksInteractorDataSource?
    
    var presenter: ListLandmarksPresentationPreparer?
    
    var places: [VictoriaLandmark] = []
}

extension ListLandmarksInteractor: ListLandmarksRequestable {

    func fetchLandmarks(request: ListLandmarks.FetchLandmarks.Request) {
//        , "hauntedHouse"
        
//        let landmark =  dataSource!.getlandmarkList(self)

//        print("444444444444444444444 \(landmark)")
        let landmark = [ "temple"]

        ApiHelper.instance().getARLandMarkByTypes(types: landmark){
            //不希望閉包內持有self,所以用 weak self

            [weak self] (isSuccess) in
            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
                return
            }
            if (isSuccess){
                print("success")

                weakSelf.places = VictoriaData_Landmarks.landmarks
                let landmarks =  weakSelf.places.enumerated().map({ $1.landmark(withIndex: $0) })
                weakSelf.presenter?.presentLandmarks(response: ListLandmarks.FetchLandmarks.Response(landmarks: landmarks))

            }else{
                print("failed")

            }
        }
        
        
        places = VictoriaData_Landmarks.landmarks
        let landmarks = places.enumerated().map({ $1.landmark(withIndex: $0) })
        presenter?.presentLandmarks(response: ListLandmarks.FetchLandmarks.Response(landmarks: landmarks))
    }
}

extension ListLandmarksInteractor: ListLandmarksDataStorer {
    func place(forIndex index: Int) -> VictoriaLandmark? {
        guard places.indices.contains(index) else {
            return nil
        }
        return places[index]
    }
}

//fileprivate extension Mountain {
//    func landmark(withIndex index: Int) -> Landmark {
//        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
//                                  altitude: altitude, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
//        return Landmark(name: name, location: location, details: <#String?#>, index: index)
//    }
//}

fileprivate extension VictoriaLandmark {
    func landmark(withIndex index: Int) -> Landmark {
        let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                  altitude: 0, horizontalAccuracy: 1, verticalAccuracy: 1, timestamp: Date())
        return Landmark(name: name, location: location, details: details, index: index)
    }
}


