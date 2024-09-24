//검색창에서 지하철명 검색

import UIKit
import MapKit

class SubwaySearchController: UIViewController {
    
    func searchForSubwayStation(query: String, mapView: MKMapView, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let error = error {
                print("지하철역 검색 중 오류 발생: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let response = response, let mapItem = response.mapItems.first else {
                print("검색된 지하철역이 없습니다.")
                completion(nil)
                return
            }
            
            let coordinate = mapItem.placemark.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            completion(coordinate)
        }
    }
}
