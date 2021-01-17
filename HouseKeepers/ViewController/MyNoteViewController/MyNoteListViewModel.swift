//
//  MyNoteListViewModel.swift
//  HouseKeepers
//
//  Created by developer on 2020/12/15.
//

import UIKit

class MyNoteListViewModel{
    
    var noteArray = [NoteModel]()
    
    var houseName = Box("")
    var pattern = Box(" ")
    var ping = Box(0)
    var price = Box(0)
    var priceOfPing = Box(0)
    var noteImgs: Box<UIImage?> = Box(nil)
    
    var onRequestEnd: (() -> Void)?
    
    init() {
        
    }
    
    
    //取得資料
    func fetchData(){
        // Api network
        // houseArray = ....
        // Api network end
    }
    
//    func changeLocation(to newLocation: String) {
//      locationName.value = "Loading..."
//      geocoder.geocode(addressString: newLocation) { [weak self] locations in
//        guard let self = self else { return }
//        if let location = locations.first {
////          self.locationName.value = location.name
//          self.fetchWeatherForLocation(location)
//          return
//        }
//      }
//    }
//
//    private func fetchNote(){
//        ApiHelper.instance().getByArea(ping:50,range:2){
//            [weak self] (isSuccess) in
//            guard let weakSelf = self else {  //如果此 weakself 賦值失敗，就 return
//                return
//            }
//            if (isSuccess){
//                print("success")
//                
//                weakSelf.markerDataList.getMarkerDatas()
//                    .map{ MyMarker(markerData: $0) }
//                    .forEach {
//                        let item = ClusterItem(markerData: $0.markerData)
////                        item.markerData.address = $0.markerData.address
//                        self?.clusterManager.add(item)
//                    }
//                self?.clusterManager.cluster()
//           
//            }else{
//                print("failed")
//             
//            }
//        }
//    }
////
//    private func fetchWeatherForLocation(_ location: Location) {
//       WeatherbitService.weatherDataForLocation(
//       latitude: location.latitude,
//       longitude: location.longitude) { [weak self] (weatherData, error) in
//         guard
//           let self = self,
//           let weatherData = weatherData
//           else {
//             return
//           }
//       }
//     }
    
}
