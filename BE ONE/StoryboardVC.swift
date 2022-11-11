//
//  StoryboardVC.swift
//  streamingSong
//
//  Created by Kurt Warson on 17/08/2018.
//  Copyright © 2018 Stars. All rights reserved.
//

import UIKit

enum Controller {
    case scrollView
    case newsView
    case knipoogView
    case messageView
}
extension Controller {
    var vc:UIViewController {
        var viewCtrl :UIViewController!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch self {
        case .scrollView:
            viewCtrl = storyboard.instantiateViewController(withIdentifier :"ScrollViewController")
     
        case .newsView:
            viewCtrl = storyboard.instantiateViewController(withIdentifier :"DigitalezendersViewController")
        case .knipoogView:
            viewCtrl = storyboard.instantiateViewController(withIdentifier :"KnipoogViewController")
            case .messageView:
                     viewCtrl = storyboard.instantiateViewController(withIdentifier :"MessageViewController")
     
        }
        return viewCtrl
    }
}
