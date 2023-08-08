//
//  BaggleStamp.swift
//  Baggle
//
//  Created by youtak on 2023/08/08.
//

import SwiftUI

struct BaggleStamp: View {

    let status: BaggleStampStatus

    var body: some View {
        status.image
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(status.degrees))
    }
}

struct BaggleStamp_Previews: PreviewProvider {
    static var previews: some View {
        BaggleStamp(status: .confirm)
    }
}
