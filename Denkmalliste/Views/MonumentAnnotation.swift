//
//  MonumentAnnotation.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 07.01.22.
//

import Foundation
import MapKit

class MonumentPointAnnotation: MKPointAnnotation {
    var objectID: Int
    
    init(objectID: Int) {
        self.objectID = objectID
        super.init()
    }
}


class MonumentAnnotationView: MKAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        let pinImage = UIImage(named: "Pin")
        self.image = pinImage
    }

}


