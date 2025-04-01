//
//  File.swift
//  AudioManager
//
//  Created by leehyeonseo on 11/4/24.
//

import AVFoundation
import Foundation
import CoreLocation

class GeoInfo{
    var latitude : Double
    var longtitude : Double
    var regionName : String
    init(
        latitude: Double,
        longtitude: Double,
        regionName: String
    ){
        self.latitude = latitude
        self.longtitude = longtitude
        self.regionName = regionName
    }
}

class GPSManager: NSObject, CLLocationManagerDelegate {
    private var checkDistance : CLLocationDistance = 10;
    private var locationManager: CLLocationManager = CLLocationManager()
    private var localNotifactionManager: LocalNotificationManager?
    private var geoList:Array<GeoInfo> = []
    private var geoDict:Dictionary<String, GeoInfo> = [:]
    private var lastDate:Date = Date()
    
    private var latitude: CLLocationDegrees = 0.0;
    private var longitude: CLLocationDegrees = 0.0;
    private var loopCount = 0;
    
    private var index = 0;
    private var geoName: Array<String> = ["A1", "A2", "A3", "A4", "A5", "B1", "B2", "B3", "B4", "B5"]
    
    private var targetCoordinates:Array<CLLocationCoordinate2D> = []
    
    private var targetRegionName : String = "";
    public var boolCheck = false;
    override init() {
        super.init()
        
        // CLLocationManager 인스턴스를 초기화
        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation  // 고정밀도 위치 추적
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 고정밀도 위치 추적
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false  // 위치 추적이 자동으로 멈추지 않도록 설정
        
        
        requestLocationPermission()
        
        localNotifactionManager = LocalNotificationManager()
        locationManager.allowsBackgroundLocationUpdates = true
        startTrackingLocation()
    }

    // 위치 업데이트 콜백
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let currentDate = Date()
        let timeDifference = currentDate.timeIntervalSince(lastDate)
        lastDate = currentDate
        print("UpdateTime: \(timeDifference)")
        print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        print("================================")
        
        // 여기에 서버로 위치 데이터를 전송하거나 다른 처리를 할 수 있습니다.
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        
        if(!targetRegionName.isEmpty){
            let distance = location.distance(from:
                                        CLLocation(
                                            latitude: CLLocationDegrees(geoDict[targetRegionName]!.latitude), longitude: CLLocationDegrees(geoDict[targetRegionName]!.longtitude)))
            if(distance <= checkDistance){
                checkGPS(region: "\(targetRegionName)")
            }
        }
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
    
    
    
    // 위치 권한 요청
    func requestLocationPermission() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.requestAlwaysAuthorization()  // 항상 위치 권한 요청
                self.startTrackingLocation();
            }
        }
    }

    // 위치 추적 시작
    func startTrackingLocation() {
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()  // 항상 위치 권한 요청
            }
        }
        
    }
    
    public func registGPS(unsafeJsonString: UnsafePointer<CChar>){
        let jsonString = String(cString: unsafeJsonString);
        
        if let data = jsonString.data(using: .utf8) {
            do {
                if let doubleArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Double] {
                    let floatArray = doubleArray.map{ Double($0) }
                    let geoInfo  = GeoInfo(
                                            latitude: floatArray[0],
                                            longtitude: floatArray[1],
                                            regionName: geoName[index]
                                        )
                    geoDict[geoName[index]] = geoInfo;
                    index+=1
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }else{
            print("JsonData Not Found")
        }
        
    }
    
    
    public func checkGPS(region: String){
        
        localNotifactionManager?.sendNotification(title: "Ryun", body: "\(region) 도착", seconds: 1.0)
    }
    
    public func deleteGPS(unSafeName: UnsafePointer<CChar>) -> Bool{
        let name = String(cString: unSafeName);
        let location = CLLocation(
                                latitude: latitude,
                                longitude:  longitude
                            )
        targetRegionName = name
        let distance = location.distance(from:
                                            CLLocation(
                                                latitude: CLLocationDegrees(geoDict[name]!.latitude), longitude: CLLocationDegrees(geoDict[name]!.longtitude)))
        
        print("###################")
        print("latitude: \(String(describing: geoDict[name]?.latitude))")
        print("longtitude: \(String(describing: geoDict[name]?.longtitude))")
        print("distance: \(distance)")
        print("checkDistance: \(checkDistance)")
        print("###################")
        if(distance <= checkDistance){
            checkGPS(region: "\(targetRegionName)")
            targetRegionName = "";
            return true;
        }
        else
        {
            return false;
        }

    }
    
    public func returnGPS() -> UnsafePointer<CChar>?{
        print("Location latitude: \(latitude)")
        print("Location longitude: \(longitude)")
        print("================================")
        
        do{
            let data = try JSONEncoder().encode([latitude, longitude])
            let utf8Bytes = [UInt8](data)
            let ccharPointer = UnsafeMutablePointer<CChar>.allocate(capacity: utf8Bytes.count + 1)  // null

            for (index, byte) in utf8Bytes.enumerated() {
                ccharPointer[index] = CChar(byte)
            }

            ccharPointer[utf8Bytes.count] = 0
            
            return UnsafePointer(ccharPointer)
        }catch{
            return nil
        }
        
    }
}
