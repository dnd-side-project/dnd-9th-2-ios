//
//  Extension+PhotosPickerItem.swift
//  Baggle
//
//  Created by youtak on 2023/07/27.
//

import PhotosUI
import SwiftUI

/// 기존 함수 async/await으로 변환
///
/// 기존 함수 : public func loadTransferable<T>(type: T.Type, completionHandler: @escaping (Result<T?, Error>) -> Void) -> Progress where T : Transferable
extension PhotosPickerItem {
    func loadTransferable<T>(type: T.Type) async throws -> T? where T: Transferable {
        return try await withCheckedThrowingContinuation { continuation in
            self.loadTransferable(type: type) { result in
                switch result {
                case .success(let successResult):
                    continuation.resume(returning: successResult)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
