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
    }
    
    
    
}
