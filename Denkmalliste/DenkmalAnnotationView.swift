//
//  DenkmalAnnotationView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 12.12.21.
//

import UIKit
import MapKit

class DenkmalAnnotationView: MKAnnotationView {
    
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
