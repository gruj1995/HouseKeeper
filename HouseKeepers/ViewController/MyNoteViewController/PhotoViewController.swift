//
//  PhotoViewController.swift
//  HouseKeepers
//
//  Created by developer on 2021/1/9.
//

import UIKit
import Kingfisher


class PhotoViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds.size
    
    @IBAction func xMarkOnClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    var urls : [URL] = []
    
    var paths : [String] = []
  
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var photoCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        photoCV.isPagingEnabled = true
        pageControl.numberOfPages = paths.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
      
    }
    override func viewWillAppear(_ animated: Bool) {

        for i in 0..<paths.count{
            paths[i] = paths[i].replace(target: " ", withString: "%20")
            urls.append(URL(string: paths[i])!)
        }

    }
}

extension PhotoViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsPhotoCollectionViewCell", for: indexPath) as! DetailsPhotoCollectionViewCell

        //下載中動畫
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(with: urls[indexPath.row])

//        let recizing = ResizingImageProcessor(referenceSize: CGSize(width: 100*UIScreen.main.scale, height: 100*UIScreen.main.scale))
//        cell.imageView.kf.setImage(
//            with: urls[indexPath.row],
//            placeholder: UIImage(named: "house_img_01"),
//            options: [
//                .processor( recizing),
//                .scaleFactor(UIScreen.main.scale),
////                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
        
//        //調整圖片大小
//        cell.imageView.kf.setImage(with: url, placeholder: nil, options: [.backgroundDecode, .processor(CroppingImageProcessor(size: CGSize(width: 100, height:100))), .scaleFactor(UIScreen.main.scale)])
//

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
    
    //控制pageControll點點位置
       func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            self.pageControl.currentPage = Int(roundedIndex)
        }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
        
        func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
            
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        }
    
}

extension  PhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = photoCV.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

}


//class ResizableImageView: UIImageView {
//
//  override var image: UIImage? {
//    didSet {
//      guard let image = image else { return }
//
//      let resizeConstraints = [
//        self.heightAnchor.constraint(equalToConstant: image.size.height),
//        self.widthAnchor.constraint(equalToConstant: image.size.width)
//      ]
//
//      if superview != nil {
//        addConstraints(resizeConstraints)
//      }
//    }
//  }
//}



extension String{
    func replace(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString,options: .literal,range: nil)
    }
}
