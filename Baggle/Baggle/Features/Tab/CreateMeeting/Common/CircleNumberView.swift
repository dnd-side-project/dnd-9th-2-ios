//
//  CircleNumber.swift
//  Baggle
//
//  Created by youtak on 2023/08/01.
//

import SwiftUI

struct CircleNumberView: View {

    let number: String
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .center) {
            Circle()
                .fill(isSelected ? Color.primaryNormal : Color.grayD9)
                .frame(width: 22, height: 22)

            Text(number)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}

struct CircleNumberView_Previews: PreviewProvider {
    static var previews: some View {
        CircleNumberView(number: "1", isSelected: true)
            .previewLayout(.sizeThatFits)
    }
}
