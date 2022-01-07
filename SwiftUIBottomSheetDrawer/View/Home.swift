//
//  Home.swift
//  SwiftUIBottomSheetDrawer
//
//  Created by JeongminKim on 2022/01/07.
//

import SwiftUI

struct Home: View {
    // Search text binding value
    @State var searchText: String = ""
    
    // Gesture properties
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
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
            .blur(radius: getBlurRadius())
            .ignoresSafeArea()
            
            // For getting height for drag gesture
            GeometryReader { proxy -> AnyView in
                let height = proxy.frame(in: .global).height
                
                return AnyView(
                    ZStack {
                        // Bottom Sheet
                        BlurView(style: .systemThinMaterialDark)
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        
                        VStack {
                            Capsule()
                                .fill(Color.white)
                                .frame(width: 60, height: 4)
                                .padding(.top)
                            
                            TextField("Search", text: $searchText)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(BlurView(style: .dark))
                                .cornerRadius(10)
                                .colorScheme(.dark)
                                .padding(.top, 10)
                            
                            // ScrollView content
                        }
                        .padding(.horizontal)
                        .frame(maxHeight: .infinity, alignment: .top)
                    }
                    .offset(y: height - 100)
                        .offset(y: -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, state, transcation in
                        state = value.translation.height
                        onChange()
                    }).onEnded({ value in
                        let maxHeight = height - 100
                        withAnimation {
                            // Loginc conditions for moving states
                            // Up down or mid
                            if -offset > 100 && -offset < maxHeight / 2 {
                                // Mid
                                offset = -(maxHeight / 3)
                            } else if -offset > maxHeight / 2 {
                                offset = -maxHeight
                            } else {
                                offset = 0
                            }
                        }
                        // Storing last offset, so that the gesture can continue from the last position
                        lastOffset = offset
                    }))
                        
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    func onChange() {
        DispatchQueue.main.async {
            self.offset = gestureOffset + lastOffset
        }
    }
    
    // Blur radius for background
    func getBlurRadius() -> CGFloat {
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
