//
//  Home.swift
//  SwiftUIBottomSheetDrawer
//
//  Created by JeongminKim on 2022/01/07.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack {
            // For getting frame for image
            GeometryReader { proxy in
                
                let frame = proxy.frame(in: .global)
                
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: frame.width, height: frame.height)
                
            }
            .ignoresSafeArea()
            
            // For getting height for drag gesture
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        // Bottom Sheet
                        BlurView(style: .systemThinMaterialDark)
                    }
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
