//
//  ViewSection.swift
//  MStructure
//
//  Created by Mephrine on 2020/02/19.
//  Copyright © 2020 MUtils. All rights reserved.
//

import Differentiator
import RxDataSources


/**
 # (S) ViewSection
 - Author: Mephrine
 - Date: 20.02.11
 - Note: 공인인증서 선택 화면 TableView에서 사용되는 Section 구조체
*/
//struct ViewSection {
//    var items: [Item]
//}
//
//extension ViewSection: SectionModelType {
//    public typealias Item = Certificate
//
//    init(original: ViewSection, items: [Item]) {
//        self = original
//        self.items = items
//    }
//}



//enum ViewSection {
//    case none([ViewSectionItem])
//}
//
//extension ViewSection: SectionModelType {
//    var items: [ViewSectionItem] {
//        switch self {
//        case .none(let items): return items
//        }
//    }
//
//    init(original: ViewSection, items: [ViewSectionItem]) {
//        switch original {
//        case .none:
//            self = .none(items)
//            break
//        }
//    }
//}
//
//enum ViewSectionItem {
//    case certList(CertificateCellVM)
//}
//
