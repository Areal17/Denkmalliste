//
//  MonumentAnnotation.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 07.01.22.
//

import Foundation
import MapKit


enum MonumentType {
    case building
    case garden
    case ensable
}

class MonumentPointAnnotation: MKPointAnnotation {
    var objectID: Int
    var kindOfMonument: MonumentType?
    init(objectID: Int) {
        self.objectID = objectID
        super.init()
    }
}


class MonumentAnnotationView: MKAnnotationView {
    
    static let ReuseID = "monumentAnnotation"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        clusteringIdentifier = "monument"
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        let pinImage = UIImage(named: "Pin")
        self.image = pinImage
        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

}


class GardenMonumentAnnotationView: MKAnnotationView {
    
    static let ReuseID = "gardenMonumentAnnotation"
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.annotation = annotation
        clusteringIdentifier = "gardenMonument"
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        let pinImage = UIImage(named: "GreenPin")
        self.image = pinImage
    }
    
}

