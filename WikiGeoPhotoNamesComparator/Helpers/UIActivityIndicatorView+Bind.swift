//
//  UUActivityIndicatorView+Bind.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 08.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    static func bindActivityIndicatorTo<viewController: UIViewController>(viewController: viewController) -> UIActivityIndicatorView{
    
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.center = viewController.view.center
        activityView.color = UIColor.black
        activityView.hidesWhenStopped = true
        viewController.view.addSubview(activityView)
    
        return activityView
    }

}
