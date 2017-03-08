//
//  NetworkManager.swift
//  WikiGeoPhotoNamesComparator
//
//  Created by Андрей Рожков on 07.03.17.
//  Copyright © 2017 AndreyRozhkov. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let endPoint = "https://en.wikipedia.org/w/api.php"
    
    //MARK: Data downloading
    
    func downloadImagesDataWith(_ location: Location, completionHandler: @escaping (_: [String : Any]?) -> Void) {
    
        Alamofire.request("\(NetworkManager.endPoint)?action=query&prop=images&imlimit=max&generator=geosearch&ggsradius=10000&ggscoord=\(location.lat!)%7C\(location.lon!)&ggslimit=50&format=json").responseJSON { response in
            
        switch response.result {
        case .success: break
        case .failure:
            completionHandler(nil)
        }
        
        if let result = response.result.value as? [String : Any] {
                completionHandler(result)
        }
        }
    }
  
    
    
}
