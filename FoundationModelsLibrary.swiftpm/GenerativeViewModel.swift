import SwiftUI
import FoundationModels

@available(iOS 26.0, *)
@MainActor
class GenerativeViewModel: ObservableObject {
    @Published var response: GeneratedFact? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var model = SystemLanguageModel.default
    private let instructions = "Motivational speaker for Lloyds Banking Group customer-based marketing"

    func testLanguageModelUsingGenerable() async {
        isLoading = true
        errorMessage = nil

        guard modelIsAvailable else {
            print("Model not available - device may not support Apple Intelligence")
            isLoading = false
            return
        }

        do {
            let session = LanguageModelSession(
                instructions: instructions
            )
            let prompt = "Provide one inspiring banking fact."
            let options = GenerationOptions(temperature: 1.0)

            let response = try await session.respond(
                to: prompt,
                generating: GeneratedFact.self,
                options: options
            )

            // The model returns a Swift object, no JSONDecoder needed
            self.response = response.content

            print("Response: \(response.content)")
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            handleError(error)
            isLoading = false
        }
    }

    private var modelIsAvailable: Bool {
        // Check if the SystemLanguageModel is available
        return SystemLanguageModel.default.availability == .available
    }

    private func handleError(_ error: Error) {
        print("Error: \(error)")

        // Handle FoundationModels specific errors
        if let generationError = error as? LanguageModelSession.GenerationError {
            switch generationError {
            case .exceededContextWindowSize:
                print("Context window exceeded - session too large")
            case .guardrailViolation:
                print("Content violates safety guardrails")
            default:
                print("Other generation error: \(generationError)")
            }
        } else if error.localizedDescription.contains("UnifiedAssetFramework") {
            print("Model assets not available")

        } else {
            print("General error: \(error.localizedDescription)")
        }
        errorMessage = error.localizedDescription
    }
}
