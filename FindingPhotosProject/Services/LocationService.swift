//
//  LocationService.swift
//  FindingPhotosProject
//
//  Created by 강창혁 on 2023/03/28.
//

import Foundation
import CoreLocation

import RxSwift

final class LocationService {
    
    static let shared = LocationService()
    let locationManager: CLLocationManager!
    
    private init() {
        self.locationManager = CLLocationManager()
    }
    func getPlaceMark(location: CLLocation) -> Observable<String?> {
        Observable.create { observer in
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { placeMark, _ in
                observer.onNext(placeMark?.last?.thoroughfare)
            }
            return Disposables.create()
        }
    }
    func getPhthoStudios(currentAddress: String?) -> Observable<PhotoStudios> {
        Observable.create { observer in
            var urlComponents = URLComponents(string: "https://openapi.naver.com/v1/search/local.json")
            //query 설정
            let query = URLQueryItem(name: "query", value: (currentAddress ?? "") + "인생네컷")
            let display = URLQueryItem(name: "display", value: "5")
            urlComponents?.queryItems = [query, display]
            let url = urlComponents?.url
            // http header 설정
            var urlRequest = URLRequest(url: url!)
            urlRequest.addValue("qoBCRUhvijbwMbPTrGqQ", forHTTPHeaderField: "X-Naver-Client-Id")
            urlRequest.addValue("j73jSXM_BZ", forHTTPHeaderField: "X-Naver-Client-Secret")
            // task
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                    
                guard let data else { return }
                guard let photoStudios = self.parseJSON(data) else { return }
                observer.onNext(photoStudios)
                observer.onCompleted()
            }
            dataTask.resume()
            return Disposables.create()
        }
    }
    // json parsing
    func parseJSON(_ data: Data) -> PhotoStudios? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(PhotoStudios.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
