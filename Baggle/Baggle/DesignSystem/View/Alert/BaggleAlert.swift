//
//  BaggleAlert.swift
//  Baggle
//
//  Created by youtak on 2023/09/06.
//

import SwiftUI

struct BaggleAlert: View {
    
    @Binding var isPresented: Bool
    
    private var alertType: AlertType?
    private var action: () -> Void
    
    init(
        isPresented: Binding<Bool>,
        alertType: AlertType?,
        action: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.alertType = alertType
        self.action = action
    }
    
    var body: some View {
        ZStack {
            if isPresented, let alertType = alertType {
                if alertType.buttonType == .one {
                    BaggleAlertOneButton(
                        isPresented: $isPresented,
                        title: alertType.title,
                        description: alertType.description,
                        buttonTitle: alertType.buttonTitle
                    ) {
                        action()
                    }
                } else { // Button 2개
                    BaggleAlertTwoButton(
                        isPresented: $isPresented,
                        title: alertType.title,
                        description: alertType.description,
                        alertType: rightButtonType(alertType.buttonType),
                        rightButtonTitle: alertType.buttonTitle,
                        leftButtonAction: nil
                    ) {
                        action()
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: self.isPresented)
    }
}

extension BaggleAlert {
    private func rightButtonType(_ alertButtonType: AlertButtonType) -> RightAlertButtonType {
        return alertButtonType == .two(.destructive) ? .destructive : .none
    }
}

struct BaggleAlert_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray11.opacity(0.7)
            
            BaggleAlert(
                isPresented: .constant(true),
                alertType: AlertMeetingDetailType.delete
            ) {
                print("눌렀어")
            }
        }
    }
}
