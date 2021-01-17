
import UIKit

class HelperFirstTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var titleLB: UILabel!
    
    @IBOutlet weak var littleLB: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.x = 20//調整x起點
            frame.size.height -= 1 * frame.origin.x//調整高度
            frame.size.width -= 2 * frame.origin.x
            
            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        
//        layer.cornerRadius = 20
//        layer.masksToBounds = false//超過框線的地方會被裁掉
        
    }
}
