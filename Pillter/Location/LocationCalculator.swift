//내 현재 위치와 약국 거리를 계산하는 함수

import CoreLocation

class LocationCalculator {
    
    // 두 위치 간의 거리를 계산하는 함수
    static func calculateDistance(from currentLocation: CLLocation, to destinationLocation: CLLocation) -> CLLocationDistance {
        return currentLocation.distance(from: destinationLocation)
    }
    
    // 거리를 m 또는 km 단위로 변환하는 함수
    static func formatDistance(_ distanceInMeters: CLLocationDistance) -> String {
        if distanceInMeters < 1000 {
            return String(format: "%.0f m", distanceInMeters)  // 1000m 미만이면 m 단위로 표시
        } else {
            let distanceInKilometers = distanceInMeters / 1000
            return String(format: "%.1f km", distanceInKilometers)  // 1000m 이상이면 km 단위로 표시
        }
    }
}
