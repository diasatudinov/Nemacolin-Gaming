//
//  NEGLoaderView.swift
//  Nemacolin Gaming
//
//

import SwiftUI

struct NEGLoaderView: View {
    @State private var scale: CGFloat = 1.0
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer?
    var body: some View {
        ZStack {
            ZStack {
                Image(.loaderBGNEG)
                    .resizable()
                    
                Color.black.opacity(0.6)
                
            }.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Image(.loaderLogoNEG)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                   
            }
            .padding(.vertical, 28)
            
            VStack {
              
                Spacer()
                
                ZStack {
                    Image(.loaderBorderNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                    
                    Image(.loaderBorderBgNEG)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 295)
                        .mask(
                            Rectangle()
                                .frame(width: progress * 295)
                                .padding(.trailing, (1 - progress) * 295)
                        )
                }
               
            }.padding(.bottom, 50)
            
            
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if progress < 1 {
                progress += 0.01
            } else {
                timer.invalidate()
            }
        }
    }
}

#Preview {
    NEGLoaderView()
}
