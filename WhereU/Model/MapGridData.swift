//
//  MapGridData.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/06.
//

import Foundation
struct MapGridData {
  let re = 6371.00877    // 사용할 지구반경  [ km ]
  let grid = 5.0         // 사용할 지구반경  [ km ]
  let slat1 = 30.0       // 표준위도       [degree]
  let slat2 = 60.0       // 표준위도       [degree]
  let olon = 126.0       // 기준점의 경도   [degree]
  let olat = 38.0        // 기준점의 위도   [degree]
  let xo = 42.0          // 기준점의 X좌표  [격자거리] // 210.0 / grid
  let yo = 135.0         // 기준점의 Y좌표  [격자거리] // 675.0 / grid
}
