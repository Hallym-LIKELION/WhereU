//
//  OpenXlsx.swift
//  WhereU
//
//  Created by 이은재 on 2023/08/05.
//

import Foundation
import CoreXLSX

class OpenXlsx {
    public var fileName: String
    public var fileType: String
    public var filePath: String?
    
    static let shared = OpenXlsx()
    
    init(fileName: String, fileType: String, filePath: String?) {
        self.fileName = fileName
        self.fileType = fileType
        self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
    }
    
    convenience init() {
        self.init(fileName: "XYFromAddress", fileType: "xlsx", filePath: nil)
    }
    // 기상청 api를 사용하기 위해서 엑셀 파일을 통해 지역에 따른 격자값(x,y)를 가져오는 메소드
    func getXYFromAddress(_ address: String, completion: @escaping (_ x: Int?, _ y: Int?) -> Void) {
        DispatchQueue.global().async {
            if let fpath = self.filePath {
                // 엑셀 파일 가져오기
                guard let file = XLSXFile(filepath: fpath) else {
                    completion(nil, nil)
                    fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
                }
                do { // 파일에서 excel의 통합문서를 지칭하는 workbook을 배열로 반환. 여기서는 weatherPosition.xlsx
                    guard let wbk = try file.parseWorkbooks().first else {
                        completion(nil, nil)
                        return
                    }
                    // workbook에서 sheet이름과 그 경로를 순회하며 name(안써서 _으로 표기함)과 path 변수에 반환
                    guard let (_, path) = try file.parseWorksheetPathsAndNames(workbook: wbk).first else {
                        completion(nil, nil)
                        return
                    }
                    // sheet의 경로(path)를 이용하여 해당 sheet을 worksheet 변수에 반환
                    let worksheet = try file.parseWorksheet(at: path)
                    
                    if let sharedStrings = try file.parseSharedStrings() {
                        let rowStrings = worksheet.cells(atRows: (2...3796))
                            .compactMap { $0.stringValue(sharedStrings) }
                        
                        for (index, value) in rowStrings.enumerated() {
                            if value == address {
                                print("주소 : \(value), x : \(rowStrings[index+1]), y: \(rowStrings[index+2])")
                                completion(Int(rowStrings[index+1]), Int(rowStrings[index+2]))
                                return
                            }
                        }
                        completion(nil, nil)
                    }
                    
                } catch {
                    completion(nil, nil)
                    print("openXlsx에러 발생 : \(error.localizedDescription)")
                }
            }
            else { completion(nil, nil) }
        }
    }
}
