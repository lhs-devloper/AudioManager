//
//  File.swift
//  AudioManager
//
//  Created by leehyeonseo on 11/4/24.
//

import Foundation
import CoreLocation

class GPSManager: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager?
    private var geoList:Array<Array<Float>> = []
    
    private var latitude: CLLocationDegrees = 0.0;
    private var longitude: CLLocationDegrees = 0.0;
    override init() {
        super.init()
        
        // CLLocationManager 인스턴스를 초기화
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation  // 고정밀도 위치 추적
        locationManager?.pausesLocationUpdatesAutomatically = false  // 위치 추적이 자동으로 멈추지 않도록 설정
        
        requestLocationPermission()
        startTrackingLocation()
    }

    // 위치 권한 요청
    func requestLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.requestAlwaysAuthorization()  // 항상 위치 권한 요청
        }
    }

    // 위치 추적 시작
    func startTrackingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }

    // 위치 업데이트 콜백
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        
        // 여기에 서버로 위치 데이터를 전송하거나 다른 처리를 할 수 있습니다.
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
    }

    // 위치 업데이트 실패 콜백
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
    }

    // 권한 변경에 따른 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            startTrackingLocation()
        }
    }
    
    public func registGPS(registLocation: Array<Float>){
        geoList.append(registLocation)
    }
    
    public func checkGPS() -> Array<Array<Float>>{
        return geoList;
    }
    
    public func returnGPS(){
        print("Location latitude: \(latitude)")
        print("Location longitude: \(longitude)")
    }
}
