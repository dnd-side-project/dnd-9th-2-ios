//
//  ProfileImageModel.swift
//  Baggle
//
//  Created by youtak on 2023/07/27.
//

import CoreTransferable
import SwiftUI

/// 앨범 앱에서 이미지를 가져오기 위한 모델
/// Transferable를 채택해줘야 함, 앨범 앱 -> Baggle 앱을 거쳐오기 위해 필요한 프로토콜
///
struct ProfileImageModel: Transferable {
    let image: Image

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(uiImage: uiImage)
            return ProfileImageModel(image: image)
        }
    }
}

/// 앨범 이미지 상태
enum AlbumImageState: Equatable {

    /// 초기 상태 - 이미지 비어 있음
    case empty

    /// 이미지 로딩 중 - iCloud에서 가져오는 경우가 있으므로 로딩이 길어질 수 있음
    case loading

    /// 로딩 성공 - 결과 이미지
    case success(Image)

    /// 로딩 실패
    case failure
}

/// 이미지 가져올 때 에러
enum TransferError: Error {
    case importFailed
}
