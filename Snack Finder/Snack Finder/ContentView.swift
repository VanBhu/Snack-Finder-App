import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    let model = GenerativeModel(name: "gemini-pro", apiKey: API_KEY)
    @State var userPrompt = ""
    @State var response: LocalizedStringKey = "What do you feel like eating?"
    @State var isLoading = false
    
    var body: some View {
        VStack {
            Text("Snack Finder")
                .font(.largeTitle)
                .foregroundStyle(.indigo)
                .fontWeight(.bold)
                .padding(.top, 40)
            ZStack{
                ScrollView{
                    Text(response)
                        .font(.title)
                        .foregroundColor(Color.indigo)
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(4)
                }
                
            }
            
            TextField("What to eat...", text: $userPrompt, axis: .vertical)
                .lineLimit(5)
                .font(.system(size: 20, weight: .medium, design: .default))
                .padding()
                .background(Color.yellow.opacity(0.8), in: Capsule())
                .disableAutocorrection(true)
                .onSubmit {
                    generateResponse()
                }
            
                
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .purple]), startPoint: .topLeading, endPoint: .bottomLeading)
            .edgesIgnoringSafeArea(.all))
    }
    
    func generateResponse(){
        isLoading = true;
        response = ""
        
        Task {
            do {
                let result = try await model.generateContent(userPrompt + ". Give me a specific brand also. Make the response text be soleley the food and the brand, no extra text should be there. Give multiple options also. Keep the output in text form so that it can be used in Python.")
                isLoading = false
                response = LocalizedStringKey(result.text ?? "No response found")
                userPrompt = ""
            } catch {
                response = "Something went wrong! \n\(error.localizedDescription)"
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}
