//
//  ClusterMonumentAnnotationView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 28.01.22.
//

import MapKit


class ClusterMonumentAnnotationView: MKMarkerAnnotationView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        if let cluster = annotation as? MKClusterAnnotation {
            if cluster.memberAnnotations.count == 2 {
                displayPriority = .defaultLow
            }
        }
//        let pinImage = UIImage(named: "ClusterPin")
//        self.image = pinImage
        self.canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    
}
