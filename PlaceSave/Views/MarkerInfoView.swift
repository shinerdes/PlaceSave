

import UIKit

class MarkerInfoView: UIView {
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarkerInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    

}
