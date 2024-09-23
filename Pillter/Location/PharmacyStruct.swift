////
//////  PharmacyStruct.swift
//////  Pillter
//////
//////  Created by 이상원 on 9/6/24.
//////
////
//// 약국 구조체 정의
//struct DataItem: Codable {
//    let dutyTel1: String
//    let dutyName: String
//    let dutyAddr: String
//    let latitude: String
//    let longitude: String
//    let mondayOpen: String?
//    let mondayClose: String?
//    let tuesdayOpen: String?
//    let tuesdayClose: String?
//    let wednesdayOpen: String?
//    let wednesdayClose: String?
//    let thursdayOpen: String?
//    let thursdayClose: String?
//    let fridayOpen: String?
//    let fridayClose: String?
//    let saturdayOpen: String?
//    let saturdayClose: String?
//    let sundayOpen: String?
//    let sundayClose: String?
//    let holidayOpen: String?
//    let holidayClose: String?
//
//    enum CodingKeys: String, CodingKey {
//        case dutyTel1 = "dutytel1"
//        case dutyName = "dutyname"
//        case dutyAddr = "dutyaddr"
//        case latitude = "wgs84lat"
//        case longitude = "wgs84lon"
//        case mondayOpen = "dutytime1s"
//        case mondayClose = "dutytime1c"
//        case tuesdayOpen = "dutytime2s"
//        case tuesdayClose = "dutytime2c"
//        case wednesdayOpen = "dutytime3s"
//        case wednesdayClose = "dutytime3c"
//        case thursdayOpen = "dutytime4s"
//        case thursdayClose = "dutytime4c"
//        case fridayOpen = "dutytime5s"
//        case fridayClose = "dutytime5c"
//        case saturdayOpen = "dutytime6s"
//        case saturdayClose = "dutytime6c"
//        case sundayOpen = "dutytime7s"
//        case sundayClose = "dutytime7c"
//        case holidayOpen = "dutytime8s"
//        case holidayClose = "dutytime8c"
//    }
//}
//
//struct Root: Codable {
//    let data: [DataItem]
//
//    enum CodingKeys: String, CodingKey {
//        case data = "DATA"
//    }
//}
