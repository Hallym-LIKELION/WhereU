//
//  GuideViewModel.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/08.
//

import Foundation

final class GuideViewModel {
    
    var selected: DisasterCategory? {
        didSet {
            if selected == .all {
                filteredGuides = guides
                return
            }
            filteredGuides = guides.filter { $0.keyword.contains(selected?.name ?? "") }
        }
    }

    var guides: Guide = [] {
        didSet {
            guidesObserver(guides)
        }
    }
    var guidesObserver: (Guide) -> Void = { _ in }
    
    var filteredGuides: Guide = []
    
    var guidesCount: Int {
        return guides.count
    }
    
    var filteredGuidesCount: Int {
        return filteredGuides.count
    }
    
    func guide(index: Int) -> GuideElement {
        return guides[index]
    }
    
    func changedSelect(index: Int) {
        self.selected = DisasterCategory.categories[index]
    }
    
    func fetchGuides() {
        GuideManager.shared.fetchAll { [weak self] result in
            switch result {
            case .success(let guides):
                self?.guides = guides
            case .failure(let error):
                self?.guides = []
                print(error)
            }
        }
    }
    
}
