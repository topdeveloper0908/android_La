import UIKit

class ReplayTableViewCell: UITableViewCell {
    var tapNewsLabelClosure : ((String) -> ())?
    
    @IBOutlet weak var newsLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    
    @IBOutlet weak var time2Label: UILabel!
    
    
//    @IBOutlet weak var imageName: UIImageView!
    
    
}
