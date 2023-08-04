//
//  CreateDescription.swift
//  Baggle
//
//  Created by youtak on 2023/08/03.
//

import SwiftUI

struct CreateDescription: View {

    let createStatus: CreateStatus
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            PageIndicator(data: CreateStatus.data, selectedStatus: createStatus)
                .padding(.vertical, 8)

            HStack {
                Text(title)
                    .font(.title2)
                Spacer()
            }
            .padding(.vertical, 12)
        }
    }
}

struct CreateDescription_Previews: PreviewProvider {
    static var previews: some View {
        CreateDescription(
            createStatus: .title,
            title: "친구들과 약속을 잡아보세요!"
        )
    }
}
