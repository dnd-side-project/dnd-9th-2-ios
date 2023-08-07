//
//  Image+.swift
//  Baggle
//
//  Created by youtak on 2023/08/07.
//

import SwiftUI

extension Image {

    // MARK: - Profile
    struct Profile {
        static let profileIn = Image("Profile_in")
        static let profilDefault = Image("Profile_default")
    }

    // MARK: - Icon
    struct Icon {

        // Function
        static let camera = Image("Camera")
        static let cameraColor = Image("CameraColor")
        static let crown = Image("Crown")
        static let delete = Image("delete")
        static let editFill = Image("Edit_Fill")
        static let editLine = Image("Edit_line")
        static let exitFill = Image("Exit_Fill")
        static let exitLine = Image("Exit_line")
        static let letter = Image("Letter")
        static let location = Image("location")
        static let share = Image("Share")
        static let siren = Image("Siren")

        // Navigation
        static let back = Image("Back")
        static let backTail = Image("BackTail")
        static let close = Image("Close")
        static let more = Image("More")
        static let next = Image("Next")
        static let nextTail = Image("NextTail")
        static let trans = Image("trans")

        // Navigation Bar
        static let homeFill = Image("Home_Fill")
        static let HomeGray = Image("Home_gray")
        static let myPageFill = Image("MyPage_Fill")
        static let myPageGray = Image("MyPage_gray")
        static let plusFill = Image("Plus_Fill")
        static let plusGray = Image("Plus_gray")
    }

    // MARK: - Illustration
    struct Illustration {
        static let camera = Image("IllustrationCamera")
        static let celebration = Image("Celebration")
        static let invitationCreate = Image("InvitationCreate")
        static let invitationReceive = Image("InvitationReceive")
    }

    // MARK: - Stamp
    struct Stamp {
        static let complete = Image("Stamp_complete")
        static let confirm = Image("Stamp_confirm")
        static let fail = Image("Stamp_fail")
    }

    // MARK: - Background
    struct Background {
        static let home = Image("Background_home")
        static let homeShort = Image("Background_home_short")
    }
}
