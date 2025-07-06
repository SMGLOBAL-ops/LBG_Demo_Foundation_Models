import SwiftUI
import Playgrounds
import FoundationModels

@available(iOS 26.0, *)
@main
struct MyApp: App {
    @StateObject private var viewModel = GenerativeViewModel()
    var body: some Scene {
        WindowGroup {
           GenerativeView(viewModel: viewModel)
        }
    }
}



