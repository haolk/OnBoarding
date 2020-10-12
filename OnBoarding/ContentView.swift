//
//  ContentView.swift
//  OnBoarding
//
//  Created by HaoLK on 10/9/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var goToHome: Bool = false
    
    var body: some View {
        ZStack {
            if goToHome {
                Text("Home")
            } else {
                OnBoardingView()
            }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name("Success")), perform: { _ in
            withAnimation { self.goToHome = true }
        })
    }
}

struct OnBoardingView: View {
    @State var maxWidth = UIScreen.main.bounds.width - 100
    @State var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color("bg")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer(minLength: 0)
                
                Text("SMART LEARN")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text("Don't waste your time. Learn something new with our app and make your skill better!")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom)
                
                Image("logo")
                    .resizable()
                
                Spacer(minLength: 0)

                // Slider....
                ZStack {
                    Capsule().fill(Color.white.opacity(0.1))
                    
                    Text("SWIPE TO START")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                    
                    HStack {
                        Capsule()
                            .fill(Color.red)
                            .frame(width: calculatorWidth() + 65)
                        Spacer(minLength: 0)
                    }
                    
                    HStack {
                        ZStack {
                            Image(systemName: "chevron.right")
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                        }
                        .foregroundColor(.white)
                        .offset(x: 5)
                        .frame(width: 65, height: 65)
                        .background(Color("red"))
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChange(value:))
                                    .onEnded(onEnd(value:)))
                        
                        Spacer()
                    }
                }
                .frame(width: maxWidth, height: 65)
                .padding(.bottom)
            }
        }
    }
    
    func calculatorWidth() -> CGFloat {
        let percent = offset / maxWidth
        return percent * maxWidth
    }
    
    func onChange(value: DragGesture.Value) {
        // Updating...
        if value.translation.width > 0 && offset <= maxWidth - 65 {
            offset = value.translation.width
        }
        
    }
    
    func onEnd(value: DragGesture.Value) {
        // Back off Animation...
        withAnimation(Animation.easeOut(duration: 0.3)) {
            if offset > 180 {
                offset = maxWidth - 65
                // Notifying User...
                // delaying for animaton complete...
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    NotificationCenter.default.post(name: NSNotification.Name("Success"), object: nil)
                }
            } else {
                offset = 0
            }
        }
    }
}
