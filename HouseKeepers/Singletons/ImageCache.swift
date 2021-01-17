//
//  ImageCache.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/2.
//

import Foundation
import UIKit

class ImageCache {
    private static var mInstance:ImageCache?
    static func sharedInstance() -> ImageCache {
        if mInstance == nil {
            mInstance = ImageCache()

        }
        return mInstance!
    }
    private init(){

    }

    private var mImages:[String:UIImage] = [String:UIImage]()

    func saveImage(aImage:UIImage,aFilename: String){
        mImages.updateValue(aImage, forKey: aFilename)
        saveLocalImage(aImage: aImage,aFilename: aFilename)
    }

    func getImage(aFilename: String) -> UIImage? {
        var _result:UIImage?
        if let _dicImage:UIImage = mImages[aFilename] {
            _result = _dicImage
        }else if let _docImage:UIImage = getLocalImage(aFilename: aFilename){
            _result = _docImage
        }
        return _result
    }

    private func saveLocalImage(aImage: UIImage, aFilename: String) {
        let _path = NSHomeDirectory().appending("/Documents/\(aFilename)")
        let _data:NSData? = aImage.pngData() as NSData?
        _data?.write(toFile: _path, atomically: true)
    }

    private func getLocalImage(aFilename: String) -> UIImage? {
//        let _path = NSHomeDirectory().stringByAppendingString("/Documents/\(aFilename)")
        let _path = NSHomeDirectory().appending("/Documents/\(aFilename)")
        do {
            let _data = try NSData(contentsOfFile: _path, options: .uncachedRead)
            return UIImage(data: _data as Data)
        } catch _ {
            return nil
        }
        
       
    }
}
