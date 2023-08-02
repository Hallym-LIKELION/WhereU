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
    var searchCompleter = MKLocalSearchCompleter() // 검색을 도와주는 변수
    
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
    
    func fetchSearchResults(results: [MKLocalSearchCompletion]) {
        searchResults = results
    }
    
    func searchResultAddress(index: Int) -> String {
        return searchResults[index].title
    }
    
    func setupSearchCompleter(delegate: MKLocalSearchCompleterDelegate) {
        searchCompleter.delegate = delegate
        searchCompleter.resultTypes = .address
    }
    
    func searchTextChanged(text: String) {
        searchText = text
        if text == "" {
            searchResults = []
        } else {
            searchCompleter.queryFragment = searchText
        }
    }
}
