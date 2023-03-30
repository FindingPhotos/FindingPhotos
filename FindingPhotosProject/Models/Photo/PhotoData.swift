//
//  aa.swift
//  FindingPhotosProject
//
//  Created by juyeong koh on 2023/03/30.
//

import RealmSwift


// 슈퍼클래스로 Object 사용, 그 후 Realm의 객체를 정의
class PhotoData: Object {
    // Realm을 사용하기 위해선 dynamic 키워드가 필요 (객체를 동적 디스패치를 사용하도록 지시)
    // 변수가 변할때 런타임시 모니터링 후 업데이트
    // ⭐️ 동적 디스패치는 실제로 Obj-C APId에서 제공 되므로 꼭 @objc키워드 필요

    @objc dynamic var date = Date() // 날짜(필수)
    @objc dynamic var imageData: NSData? = nil
    @objc dynamic var memo: String? // 메모(옵셔널)
    
    convenience init(date: Date, imageData: NSData, memo: String?) {
        self.init()
        self.date = date
        self.imageData = imageData
        self.memo = memo
    }

}

