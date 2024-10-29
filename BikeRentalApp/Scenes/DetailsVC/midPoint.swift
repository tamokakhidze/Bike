//
//  midPoint.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import Foundation
import CoreLocation

//ჩემს ლოკაციასა და ველოსიპედის ლოკაციას შორის შუა წერტილის საპოვნელი ფუნქცია
//ეს შუა წერტილი არის შემდეგ რუკის რეგიონის ცენტრი, რათა ჩატვირთვისას კარგად გამოჩნდეს

public func midPoint(of location1: CLLocation, _ location2: CLLocation) -> CLLocationCoordinate2D {
    
    //// გრადუსების გადაყვანა რადიანებში
    let latitude1 = location1.coordinate.latitude * (.pi / 180.0)
    let longitude1 = location1.coordinate.longitude * (.pi / 180.0)
    
    let latitude2 = location2.coordinate.latitude * (.pi / 180.0)
    let longitude2 = location2.coordinate.longitude * (.pi / 180.0)
    
    //// შუაწერტილის ფორმულა
    let Bx = cos(latitude2) * cos(longitude2 - longitude1)
    let By = cos(latitude2) * sin(longitude2 - longitude1)
    
    var latitude3 = atan((sin(latitude1) + sin(latitude2)) / sqrt((cos(latitude1) + Bx) * (cos(latitude1) + Bx) + (By * By)))
    
    let longitude3 = longitude1 + atan2(By, cos(latitude1) + Bx)
                         
    //// ისევ გრადუსებში გადაყვანა
    let result = CLLocationCoordinate2D(latitude: latitude3 * 180.0 / .pi, longitude: longitude3 * 180.0 / .pi)
    
    return result
}


