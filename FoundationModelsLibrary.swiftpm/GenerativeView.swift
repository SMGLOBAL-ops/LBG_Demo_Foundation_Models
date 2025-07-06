import Foundation
import SwiftUI

@available(iOS 26.0, *)
struct GenerativeView: View {
    @ObservedObject var viewModel: GenerativeViewModel

    var body : some View {
        ZStack {
            Color.green.ignoresSafeArea()
            VStack(alignment: .center, spacing: 50) {
                Text(viewModel.response?.fact ?? "")
                    .frame(width: 250, height: 200, alignment: .center)
                    .foregroundColor(.black)
                    .overlay {
                            Rectangle()
                                .frame(width: 350, height: 200, alignment: .center)
                                .opacity(0.3)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(20)
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                    }
                generateButton
                    .padding(.top, 60)
            }
        }
    }

    @ViewBuilder
    private var generateButton: some View {
        Button( viewModel.isLoading ? "Generating inspiring quote..." : "Tap to be inspired") {
            Task {
                await viewModel.testLanguageModelUsingGenerable()
            }
        }
        .padding()
        .background(Color.black)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(color: .purple,radius: 25)
    }
}

