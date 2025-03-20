// ContentView.swift
import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = TranslationViewModel()
    @State private var showingHistory = false
    @State private var isTextCopied = false
    @State private var isTranslating = false
    @State private var translationAppeared = false
    
    // Extended language options
    let languages = [
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
        ("ja", "Japanese"),
        ("zh", "Chinese"),
        ("ru", "Russian"),
        ("pt", "Portuguese"),
        ("ar", "Arabic"),
        ("ko", "Korean"),
        ("nl", "Dutch")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Image(systemName: "globe")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                        
                        Text("NotGoogleTranslate")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.blue)
                        
                        // Language selection with swap button
                        HStack {
                            Picker("From", selection: $viewModel.sourceLanguage) {
                                ForEach(LanguageManager.languages) { language in
                                    HStack(spacing: 8){
                                        //Text(language.flag)
                                        Text(language.name)
                                    }.tag(language.code)
                                }
                            }
                            .frame(maxWidth: .infinity)
                                .accentColor(.blue)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                            Button(action: {
                                let temp = viewModel.sourceLanguage
                                viewModel.sourceLanguage = viewModel.targetLanguage
                                viewModel.targetLanguage = temp
                            }) {
                                Image(systemName: "arrow.left.arrow.right")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Circle().fill(Color.blue.opacity(0.1)))
                            }
                            
                            Picker("To", selection: $viewModel.targetLanguage) {
                                ForEach(languages, id: \.0) { language in
                                    Text(language.1).tag(language.0)
                                }
                            }
                            .frame(maxWidth: .infinity)
                                .accentColor(.blue)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                )
                        }
                        .padding(.horizontal)
                        
                        // Source text field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Enter text")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $viewModel.sourceText)
                                .frame(height: 120)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            
                            // Clear button for source text
                            if !viewModel.sourceText.isEmpty {
                                Button(action: {
                                    viewModel.sourceText = ""
                                }) {
                                    Text("Clear")
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.trailing, 5)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Translate button
                        Button(action: {
                            isTranslating = true
                            translationAppeared = false
                            Task {
                                await viewModel.translate()
                                isTranslating = false
                                
                                withAnimation(.easeIn(duration: 0.5)) {
                                    translationAppeared = true
                                }
                            }
                            
                        }) {
                            HStack {
                                Image(systemName: "globe")
                                Text("Translate")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                viewModel.sourceText.isEmpty || viewModel.isTranslating ?
                                    Color.gray : Color.blue
                            )
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .disabled(viewModel.sourceText.isEmpty || viewModel.isTranslating)
                        .padding(.horizontal)
                        
                        // Translation result
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Translation")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                // Copy button
                                if !viewModel.translatedText.isEmpty {
                                    Button(action: {
                                        UIPasteboard.general.string = viewModel.translatedText
                                        withAnimation {
                                            isTextCopied = true
                                        }
                                        
                                        // Reset the copied status after 2 seconds
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation {
                                                isTextCopied = false
                                            }
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: isTextCopied ? "checkmark" : "doc.on.doc")
                                            Text(isTextCopied ? "Copied" : "Copy")
                                                .font(.footnote)
                                        }
                                        .foregroundColor(isTextCopied ? .green : .blue)
                                    }
                                }
                            }
                            
                            if viewModel.isTranslating {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .scaleEffect(1.2)
                                        .padding()
                                    Spacer()
                                }
                                .frame(height: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                            } else {
                                TextEditor(text: $viewModel.translatedText)
                                    .frame(height: 120)
                                    .padding(10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.white)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .disabled(true)
                            }
                        }
                        .padding(.horizontal)
                        
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding()
                        }
                        
                        Spacer()
                        
                        // Navigation to history
                        Button(action: {
                            showingHistory = true
                        }) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("View History")
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(15)
                        }
                        .padding(.bottom, 20)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .sheet(isPresented: $showingHistory) {
                HistoryView(viewModel: viewModel)
            }
        }
    }
}
