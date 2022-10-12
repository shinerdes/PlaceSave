

import UIKit

class StoreTypeCell: UITableViewCell {


    @IBOutlet weak var storeTypeImage: UIImageView!
    @IBOutlet weak var storeTypeLbl: UILabel!
    @IBOutlet weak var storeTypeCheckImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
