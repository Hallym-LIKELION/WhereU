//
//  SearchViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/02.
//

import Foundation
import MapKit

final class SearchViewModel {
    
    var searchText: String = "" {
        didSet {
            searchTextObserver(searchText)
        }
    }
    var searchTextObserver: (String) -> Void = { _ in }
    
    var searchResults = [MKLocalSearchCompletion]() // 검색 결과를 담는 변수
    var searchCompleter: MKLocalSearchCompleter? = MKLocalSearchCompleter() // 검색을 도와주는 변수
    
    var searchResultText: String {
        return "'\(searchText)' 검색 결과"
    }
    
    var searchResultCount: Int {
        return searchResults.count
    }
    
    var searchResultTextIsHidden: Bool {
        return searchText == "" ? true : false
    }
    
    var noResultLabelIsHidden: Bool {
        return !searchResultTextIsHidden && searchResultCount == 0 ? false : true
    }
    
    var clearButtonIsHidden: Bool {
        return searchText == "" ? true : false
    }
    
    func fetchSearchResults(results: [MKLocalSearchCompletion]) {
        searchResults = results
    }
    
    func searchResultAddress(index: Int) -> String {
        return searchResults[index].title
    }
    
    func setupSearchCompleter(delegate: MKLocalSearchCompleterDelegate) {
        searchCompleter?.delegate = delegate
        searchCompleter?.resultTypes = .address
        searchCompleter?.region = MKCoordinateRegion(MKMapRect.world)
    }
    
    func searchTextChanged(text: String) {
        searchText = text
        
        if text == "" {
            searchResults = []
        } else {
            searchCompleter?.queryFragment = searchText
        }
        
    }
    
    func findCurrentLocation() {
        LocationManager.shared.reverseGeoCodeLocation { [weak self] address, _ in
            self?.searchTextChanged(text: address)
        }
    }
    
    func search(
        for suggestedCompletion: MKLocalSearchCompletion,
        completion: @escaping (Int,Int) -> Void
    ) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest, completion: completion)
    }
    
    private func search(
        using searchRequest: MKLocalSearch.Request,
        completion: @escaping (Int,Int) -> Void
    ) {
        // 검색 지역 설정
        searchCompleter?.region = MKCoordinateRegion(MKMapRect.world)
        
        // 검색 유형 설정
        searchRequest.resultTypes = .pointOfInterest
        // MKLocalSearch 생성
        let localSearch = MKLocalSearch(request: searchRequest)
        // 비동기로 검색 실행
        localSearch.start { (response, error) in
            guard error == nil else {
                return
            }
            // 검색한 결과 : reponse의 mapItems 값을 가져온다.
            let places = response?.mapItems[0]
            guard let coord = places?.placemark.coordinate else { return }
            // 격자 좌표값을 구하기 위한 Converter
            let converter = LocationConverter()
            let (x,y) = converter.convertGrid(lon: coord.longitude, lat: coord.latitude)
            
            completion(x,y)
        }
    }
    
    deinit {
        searchCompleter = nil
    }
}
