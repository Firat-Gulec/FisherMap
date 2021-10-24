//
//  AnnonationModels.swift
//  FisherMap
//
//  Created by Fırat GÜLEÇ on 4.10.2021.
//

import UIKit
import MapKit


class AnnonationModel: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var favorite: Bool
    var createDate: Date
    
    init (title: String, subtitle: String, coordinate: CLLocationCoordinate2D, info: String, favorite: Bool, createDate: Date ) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.info = info
        self.favorite = favorite
        self.createDate = createDate
        
    }
}
