


import Alamofire
import SwiftyJSON
import GoogleMaps
import UIKit

// @escaping 。如果一個閉包被當成參數傳給一個函式，且是在函式執行完後才被呼叫執行，就是逃逸閉包。比如網路請求時會傳入一個 handler，等處理完後再回撥結果

class ApiHelper{
    
    //單例網路
    static private var apiHelper : ApiHelper?
    private init() {}
    private let serverUrl = "http://104.155.214.17:8888"
    
    static func instance() -> ApiHelper{
        if (apiHelper == nil){
            apiHelper = ApiHelper()
        }
        return apiHelper!
    }
    
    //解析json包，可成功開啟才回傳true
    private func wrappingJSON(json: JSON) -> Bool{
        let status = json["status"]
        if(status >= 400){
            print("\(String(describing: json["messages"].string))")
            return false
        }else if(status == 200){
            return true
        }
        print("something going wrong")
        return false
    }
    
    func login(handler: @escaping(_ result:Bool) -> ()){
        let afUrl = "\(serverUrl)/user/login"
        let parameter: Parameters = ["id":Global.UID]
        AF.request(afUrl,method: .post, parameters: parameter )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        //                        let jsonArr = json["messages"]
                        Global.Token = json["token"].string!
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    
    
    // 依條件篩選實價登錄結果
    func getTruePricePoint(latitude:String,longitude:String,distanceRange:String,maxHouseAge: String, minHouseAge : String,maxPerPrice: String, minPerPrice: String,  lowriseAparment:String,highriseAparment: String,midriseAparment: String,townhouse: String, businessOffice: String , handler: @escaping(Bool) -> ()){
        
        let params : Parameters = ["latitude":latitude,"longitude":longitude,"distanceRange" :distanceRange,"maxHouseAge": maxHouseAge, "minHouseAge" : minHouseAge,"maxPerPrice": maxPerPrice, "minPerPrice": minPerPrice,  "lowriseAparment":lowriseAparment,"highriseAparment": highriseAparment,"midriseAparment": midriseAparment,"townhouse": townhouse,"businessOffice": businessOffice]
        
        let afUrl = "\(serverUrl)/house/addressfilter?"
        
        AF.request(afUrl,method: .get ,parameters: params)
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let markerDataList = MarkerDataList.instance()
                        markerDataList.clear()
                        
                        for index in 0..<jsonArr.count  {
                            markerDataList.add( markerData:MarkerData(position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!), title: jsonArr[index]["address"].string!, address: jsonArr[index]["address"].string!))
                        }
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    // 取得所有實價登錄資料
    func getAllHouse( handler: @escaping(Bool) -> ()){
        
        let afUrl = "\(serverUrl)/house/getall"
        
        AF.request(afUrl,method: .get)
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let markerDataList = MarkerDataList.instance()
                        markerDataList.clear()
                        
                        for index in 0...jsonArr.count - 1 {
                            markerDataList.add( markerData:MarkerData(position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!), title: jsonArr[index]["type"].string!, address: jsonArr[index]["address"].string!))
                        }
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    // 取得該地址實價登錄資料
    func getByAddress(address:String, handler: @escaping(_ result: Bool,_ houseArray: Array<HouseModel>?)->()) {
        
        let afUrl = "\(serverUrl)/house/trueprice?"
        
        var houseArray = Array<HouseModel>()
        
        AF.request(afUrl, method: .get,parameters: ["address":address])
            .responseJSON{ response in
                switch response.result {
                case .success: // 連線成功時
                    
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        
                        //                        init(name:String, pattern: String, price: Double , ping: Double ,  houseImgs:[UIImage],address:String, position:CLLocationCoordinate2D,transactionTime:String,floor:Int)
                        
                        for index in 0...jsonArr.count - 1 {
                            
                            let room : String = (jsonArr[index]["room"].string!) != "0" ? (jsonArr[index]["room"].string!) + "房": ""
                            let hall : String = (jsonArr[index]["hall"].string!) != "0" ? (jsonArr[index]["hall"].string!) + "廳": ""
                            let health : String = (jsonArr[index]["health"].string!) != "0" ? (jsonArr[index]["health"].string!) + "衛": ""
                            let pattern = room + hall + health
                            
                            houseArray.append(HouseModel(name:"", pattern:pattern,  price: Double(jsonArr[index]["totalPrice"].string!)! , ping: Double(jsonArr[index]["ping"].string!)!,address:jsonArr[index]["address"].string!,position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!), transactionTime:jsonArr[index]["transactionTime"].string!,floor:jsonArr[index]["shiftingLevel"].string!,buildingState: jsonArr[index]["buildingState"].string!))
                        }
                        
                    }      
                    handler(true,houseArray)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false,nil)
                    break
                }
            }
        
        
    }
    
    // 取得範圍內實價登錄資料
    func getByArea(ping: Double, range: Double, handler: @escaping(Bool) -> ()){
        
        let afUrl = "\(serverUrl)/house/getbyarea?ping=\(ping)&range=\(range)"
        
        AF.request(afUrl,method: .get)
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let markerDataList = MarkerDataList.instance()
                        markerDataList.clear()
                        
                        for index in 0...jsonArr.count - 1 {
                            markerDataList.add( markerData:MarkerData(position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!), title: jsonArr[index]["buildingState"].string!, address: jsonArr[index]["address"].string!))
                            
                        }
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    
    
    // 取得所有地標
    func getAllLandMark( handler: @escaping(Bool) -> ()){
        
        let afUrl = "\(serverUrl)/landmark/getall"
        
        AF.request(afUrl,method: .get)
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let landMarkList = LandMarkList.instance()
                        landMarkList.clear()
                        
                        for index in 0...jsonArr.count - 1 {
                            landMarkList.add( landMark: LandMarkModel(name:jsonArr[index]["name"].string!, type:jsonArr[index]["type"].string!,address: jsonArr[index]["address"].string!,district:jsonArr[index]["district"].string!,position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!) ))
                        }
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
       // AR模式取得特定地標
        func getARLandMarkByTypes(types: [String] , handler: @escaping(Bool) -> ()){
            if types.count == 0{
                return;
            }
            var result = ""
            for i in 0..<types.count{
                if i != types.count-1{
                    result += types[i] + "=" + types[i] + "&"
                }else{
                    result += types[i] + "=" + types[i]
                }
            }

            let afUrl = "\(serverUrl)/landmark/filter?\(result)"

            AF.request(afUrl,method: .get )
                .responseJSON{ response in
                    switch response.result {

                    case .success: // 連線成功時
                        let json = try! JSON(data: response.data!)
                        if(self.wrappingJSON(json: json)){

                            let jsonArr = json["messages"]

                            
                            for index in 0...jsonArr.count - 1 {
                                    VictoriaData_Landmarks.landmarks.append(VictoriaLandmark(latitude: Double(jsonArr[index]["latitude"].string!)!, longitude: Double(jsonArr[index]["longitude"].string!)!, name: jsonArr[index]["name"].string!, details: jsonArr[index]["address"].string ?? ""))
                                }


                        }
                        handler(true)
                        break;

                    case .failure(let error):
                        print("error:\(error)")
                        handler(false)
                        break
                    }
                }
        }
    
    // 取得特定地標
    func getLandMarkByTypes(types: [String] , handler: @escaping(Bool) -> ()){
        if types.count == 0{
            return;
        }
        var result = ""
        for i in 0..<types.count{
            if i != types.count-1{
                result += types[i] + "=" + types[i] + "&"
            }else{
                result += types[i] + "=" + types[i]
            }
        }
        
        let afUrl = "\(serverUrl)/landmark/filter?\(result)"
        
        AF.request(afUrl,method: .get )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let landMarkList = LandMarkList.instance()
                        landMarkList.clear()
                        
                        for index in 0...jsonArr.count - 1 {
                            landMarkList.add( landMark: LandMarkModel(name:jsonArr[index]["name"].string!, type:jsonArr[index]["type"].string!,address: jsonArr[index]["address"].string!,district:jsonArr[index]["district"].string!,position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string!)!,  longitude: Double(jsonArr[index]["longitude"].string!)!) ))
                        }
                        
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    
    
    //取得自己的所有日記
    func getMyNotes(handler: @escaping(_ result:Bool) -> ()){
        let afUrl = "\(serverUrl)/note/getbyid"
        let headers: HTTPHeaders = ["token": Global.Token ]
        
        AF.request(afUrl,method: .get , headers: headers )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let noteList = MyNoteList.instance()
                        noteList.clear()
                        if jsonArr.count != 0 {
                            for index in 0...jsonArr.count - 1 {
                                let hall = jsonArr[index]["hall"].string! == "0" ? "" : "\(jsonArr[index]["hall"].string!)廳"
                                let room = jsonArr[index]["room"].string! == "0" ? "" : "\(jsonArr[index]["room"].string!)房"
                                let health = jsonArr[index]["health"].string! == "0" ? "" : "\(jsonArr[index]["health"].string!)衛"
                                let pattern = "\(hall)\(room)\(health)"
                                
                                let house = HouseModel(name: jsonArr[index]["title"].string!, pattern: pattern, price: Double(jsonArr[index]["totalPrice"].string!)!, ping: Double(jsonArr[index]["ping"].string!)!, address: jsonArr[index]["address"].string!, position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string ?? "0")!,  longitude: Double(jsonArr[index]["longitude"].string ?? "0")!), transactionTime: "", floor: "", buildingState: "")
                                
                                noteList.add( note: NoteModel(noteId: jsonArr[index]["noteid"].string!,house:house,  advantage:jsonArr[index]["advantage"].string ?? "", disadvantage:jsonArr[index]["disadvantage"].string ?? "", contactPhone:jsonArr[index]["contactPersonPhone"].string ?? "", contactName:jsonArr[index]["contactPersonName"].string ?? "", desc:jsonArr[index]["information"].string ?? "", noteImgs:nil))
                            }
                            
                        }
                    }
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
        
    }
    
    // 取得單篇筆記詳細資訊
    func getByNoteId(noteId : String ,handler: @escaping(_ result:Bool, _ note: NoteModel?) -> ()){
        let afUrl = "\(serverUrl)/note/getbynoteid?noteid=\(noteId)"
        let headers: HTTPHeaders = ["token": Global.Token ]
        
        var note : NoteModel?
        
        AF.request(afUrl,method: .get , headers: headers )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        let jsonArr = json["messages"]
                        
                        let index = 0
                        
                        let hall = jsonArr[index]["hall"].string! == "0" ? "" : "\(jsonArr[index]["hall"].string!)廳"
                        let room = jsonArr[index]["room"].string! == "0" ? "" : "\(jsonArr[index]["room"].string!)房"
                        let health = jsonArr[index]["health"].string! == "0" ? "" : "\(jsonArr[index]["health"].string!)衛"
                        let pattern = "\(hall)\(room)\(health)"
                        
                        let house = HouseModel(name: jsonArr[index]["title"].string!, pattern: pattern, price: Double(jsonArr[index]["totalPrice"].string!)!, ping: Double(jsonArr[index]["ping"].string!)!, address: jsonArr[index]["address"].string!, position: CLLocationCoordinate2D(latitude: Double(jsonArr[index]["latitude"].string ?? "0")!,  longitude: Double(jsonArr[index]["longitude"].string ?? "0")!), transactionTime: "", floor: "", buildingState: "")
                        
                        note = NoteModel(noteId: jsonArr[index]["noteId"].string!,house:house,  advantage:jsonArr[index]["advantage"].string ?? "", disadvantage:jsonArr[index]["disadvantage"].string ?? "", contactPhone:jsonArr[index]["contactPersonPhone"].string ?? "", contactName:jsonArr[index]["contactPersonName"].string ?? "", desc:jsonArr[index]["information"].string ?? "", noteImgs:nil)
                        
                        //將照片路經分割
                        let subStrings = (jsonArr[index]["imagePath"].string ?? "").split(separator: ",")
                        note?.imagePath = subStrings.compactMap{"\($0)"}
                    }
                    handler(true, note)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false, nil)
                    break
                }
            }
    }
    
    
    //新增筆記
    func postNote(title: String, address: String,ping: String, totalPrice: String, room :String, hall: String, health: String,advantage: String, disadvantage: String,  information :String, contactPersonName: String, contactPersonPhone: String, photos: [UIImage],handler: @escaping(_ result:Bool) -> ()){
        
        let afUrl = "\(serverUrl)/note/add"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data",
            "token": Global.Token
        ]
        
        
        let params : Parameters = ["title":title,"address":address,"room" :room,"hall": hall, "health" : health,"ping": ping, "totalPrice": totalPrice,  "advantage":advantage,"disadvantage": disadvantage,"information": information,"contactPersonName": contactPersonName,"contactPersonPhone": contactPersonPhone]
        
        AF.upload(multipartFormData:  { multipartFormData in
            
            if(photos.count > 0){
                for i in 0..<photos.count {
                    let imageData = photos[i].jpegData(compressionQuality: 0.5)
                    let currentTime = Date() //現在時間
                    let fileName = "MyNoteImgs.\(i)\(currentTime).jpeg"
                    multipartFormData.append(imageData!, withName: "file[]", fileName: fileName, mimeType:"image/jpeg")
                }
            }
            for (key, value) in params
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: afUrl, usingThreshold:  UInt64.init(), method: .post, headers: headers )
        .responseString(completionHandler: { (response) in
            
            print(response)
            
            if let err = response.error{
                print(err)
                handler(false)
                return
            }
            print("Succesfully uploaded")
            
            let json = response.data
            
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                print(jsonObject)
                handler(true)
            }
        })
    }
    
    //修改筆記
    func patchNote(noteId: String,title: String, address: String,ping: String, totalPrice: String, room :String, hall: String, health: String,advantage: String, disadvantage: String,  information :String, contactPersonName: String, contactPersonPhone: String,handler: @escaping(_ result:Bool) -> ()){
        
        let afUrl = "\(serverUrl)/note/update/\(noteId)"
        
        let headers: HTTPHeaders = ["token": Global.Token]
        
        
        let params : Parameters = ["title":title,"address":address,"room" :room,"hall": hall, "health" : health,"ping": ping, "totalPrice": totalPrice,  "advantage":advantage,"disadvantage": disadvantage,"information": information,"contactPersonName": contactPersonName,"contactPersonPhone": contactPersonPhone]
        
        AF.request(afUrl, method: .patch, parameters: params, headers: headers )
            .responseJSON{ response in
                
                switch response.result {
                
                case .success: // 連線成功時
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        
                        print("seccess: \(json)")
                        
                    }
                    
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    
    //修改筆記(理智重寫版)
    func modifyNote(noteId: String,title: String, address: String,ping: String, totalPrice: String, room :String, hall: String, health: String,advantage: String, disadvantage: String,  information :String, contactPersonName: String, contactPersonPhone: String, photos: [UIImage],handler: @escaping(_ result:Bool) -> ()){
        
        let afUrl = "\(serverUrl)/note/modify"
        
        let headers: HTTPHeaders = ["token": Global.Token]
        
        let params : Parameters = ["noteid":noteId,"title":title,"address":address,"room" :room,"hall": hall, "health" : health,"ping": ping, "totalPrice": totalPrice,  "advantage":advantage,"disadvantage": disadvantage,"information": information,"contactPersonName": contactPersonName,"contactPersonPhone": contactPersonPhone]
        
        AF.upload(multipartFormData:  { multipartFormData in
            
            if(photos.count > 0){
                for i in 0..<photos.count {
                    let imageData = photos[i].jpegData(compressionQuality: 0.5)
                    let currentTime = Date() //現在時間
                    let fileName = "MyNoteImgs.\(i)\(currentTime).jpeg"
                    multipartFormData.append(imageData!, withName: "file[]", fileName: fileName, mimeType:"image/jpeg")
                }
            }
            for (key, value) in params
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: afUrl, usingThreshold:  UInt64.init(), method: .post, headers: headers )
        .responseString(completionHandler: { (response) in
            print(response)
            if let err = response.error{
                print(err)
                handler(false)
                return
            }
            print("Succesfully uploaded")
            let json = response.data
            
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                print(jsonObject)
                handler(true)
            }
        })
    }
    
    //修改照片
    func postImage(noteId: String, remainPath: [String], photos: [UIImage],  handler: @escaping(_ result:Bool) -> ()){
        
        var allPath = ""
        for i in 0..<remainPath.count{
            allPath += remainPath[i]+","
        }
        
        let afUrl = "\(serverUrl)/note/imageupdate"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Content-Disposition" : "form-data",
            "token": Global.Token
        ]
        
        let params : Parameters = ["noteId":noteId,"remainPath":allPath]
        
        AF.upload(multipartFormData:  { multipartFormData in
            
            if(photos.count > 0){
                for i in 0..<photos.count {
                    let imageData = photos[i].jpegData(compressionQuality: 0.5)
                    let currentTime = Date() //現在時間
                    let fileName = "MyNoteImgs.\(i)\(currentTime).jpeg"
                    multipartFormData.append(imageData!, withName: "file[]", fileName: fileName, mimeType:"image/jpeg")
                }
            }
            for (key, value) in params
            {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: afUrl, usingThreshold:  UInt64.init(), method: .post, headers: headers )
        .responseString(completionHandler: { (response) in
            
            print(response)
            
            if let err = response.error{
                print(err)
                handler(false)
                return
            }
            print("Succesfully uploaded")
            
            let json = response.data
            
            if (json != nil)
            {
                let jsonObject = JSON(json!)
                print(jsonObject)
                handler(true)
            }
        })
    }
    
    
    //刪除筆記
    func deleteNoteByNoteId(noteId : String ,handler: @escaping(_ result:Bool) -> ()){
        let afUrl = "\(serverUrl)/note/delete/\(noteId)"
        
        AF.request(afUrl,method: .delete  )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    handler(true)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false)
                    break
                }
            }
    }
    
    //
    func getByObject(object : String ,handler: @escaping(_ result:Bool,_ object: ObjectModel?
    ) -> ()){

        let afUrl = "\(serverUrl)/helperobject/getbyobject?"
        let params : Parameters = ["object":object]
        
        AF.request(afUrl, method: .get ,parameters: params )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    
                    var objectModel = ObjectModel()
                    
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        print("\(json)")

                        objectModel.objectCount = json["objectCount"].description
                          
                        let objectMessagesArr = json["objectMessages"]
                        
                        for index in 0..<objectMessagesArr.count{
                            objectModel.objectId = objectMessagesArr[index]["id"].string!
                            objectModel.object = objectMessagesArr[index]["object"].string!
                            objectModel.objectImgPath = (objectMessagesArr[index]["imagePath"].string ?? "")
                        }
                        
                        let articleMessagesArr = json["articleMessages"]
                        
                        for index in 0..<articleMessagesArr.count{
                            objectModel.article.append(ArticleModel(articleId: articleMessagesArr[index]["articleId"].string!, title: articleMessagesArr[index]["title"].string!, object: "", type: articleMessagesArr[index]["type"].string!, imagePath: articleMessagesArr[index]["imagePath"].string ?? "", dateTime: "", articleCount: articleMessagesArr[index]["count"].string ?? "0"))
                        }
                    }

                    handler(true,objectModel)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false,nil)
                    break
                }
            }
    }
    
    func getByType(type : String ,handler: @escaping(_ result:Bool,_ articles : Array<ArticleModel>?) -> ()){
        
        let afUrl = "\(serverUrl)/helperarticle/getbytype?"

        let params : Parameters = ["type":type]
        
        
        AF.request(afUrl, method: .get ,parameters: params )
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    
                    var  articleModels : [ArticleModel] = []
                    
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        print("\(json)")

                        let jsonArr = json["messages"]
                        
                        for index in 0..<jsonArr.count{
                            
                            var article = ArticleModel(articleId: jsonArr[index]["articleId"].string!, title: jsonArr[index]["title"].string ?? "", object: "", type: jsonArr[index]["type"].string ?? "", imagePath: jsonArr[index]["imagePath"].string ?? "", dateTime: jsonArr[index]["dateTime"].string ?? "", articleCount: jsonArr[index]["count"].string ?? "0")
                            
                            article.inofrmation = jsonArr[index]["information"].string ?? ""
                            article.articleTitle = jsonArr[index]["title2"].string ?? ""
                            
                            articleModels.append(article)
                           
                        }
                    }

                    handler(true,articleModels)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false,nil)
                    break
                }
            }
    }
    
    func getByarticleId(articleId: String ,handler: @escaping(_ result:Bool,_ article : ArticleModel?) -> ()){
        
        let afUrl = "\(serverUrl)/helperarticle/getbyid?"
        let params : Parameters = ["articleId":articleId]
        let headers: HTTPHeaders = ["token": Global.Token]
        
        
        AF.request(afUrl, method: .get ,parameters: params ,headers: headers)
            .responseJSON{ response in
                switch response.result {
                
                case .success: // 連線成功時
                    print("rdfdfdfdfdfdfdfdfdfdfdfdfdfdfdf")
                    var  article = ArticleModel()
                    
                    let json = try! JSON(data: response.data!)
                    if(self.wrappingJSON(json: json)){
                        print("\(json)")

                        let jsonArr = json["messages"]
                        
                        for index in 0..<jsonArr.count{
                            
                            article  = ArticleModel(articleId: jsonArr[index]["articleId"].string!, title: jsonArr[index]["title"].string ?? "", object: "", type: jsonArr[index]["type"].string ?? "", imagePath: jsonArr[index]["imagePath"].string ?? "", dateTime: jsonArr[index]["dateTime"].string ?? "", articleCount: jsonArr[index]["count"].string ?? "0")
                            
                            article.inofrmation = jsonArr[index]["information"].string ?? ""
                            article.articleTitle = jsonArr[index]["title2"].string ?? ""
                            
                            article.object = jsonArr[index]["object"].string ?? ""
                           
                        }
                    }

                    handler(true,article)
                    break;
                    
                case .failure(let error):
                    print("error:\(error)")
                    handler(false,nil)
                    break
                }
            }
    }
    
}

