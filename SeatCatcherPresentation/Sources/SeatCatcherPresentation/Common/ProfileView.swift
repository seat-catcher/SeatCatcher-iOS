//
//  ProfileView.swift
//  SeatCatcherPresentation
//
//  Created by 황채웅 on 4/5/25.
//

import SwiftUI

struct ProfileView: View {
    
    let profile: ProfileConfig
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(profile.profileImage)
                .resizable()
                .frame(width: 68, height: 68)
                .padding(.trailing, 10)
            VStack(alignment: .leading, spacing: 6) {
                Text(profile.name)
                    .font(.B03_M)
                    .foregroundStyle(.gray300)
                Text(profile.tag.rawValue)
                    .font(.B03_SB)
                    .foregroundStyle(.scGreen)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .background(.scGreen700)
                    .clipShape(.rect(cornerRadius: 6))
            }
            Spacer(minLength: 0)
        }
    }
}
