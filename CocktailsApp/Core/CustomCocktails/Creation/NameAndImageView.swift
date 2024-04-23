//
//  NameAndImageView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 24/2/24.
//

import SwiftUI
import PhotosUI

struct NameAndImageView: View {
    @StateObject var viewModel = CustomCocktailsViewModel(firestoreManager: FirestoreManager(),
                                                          coreDataManager: CoreDataManager())
    
    @State private var textFieldText: String = ""
    @State private var cocktailName: String = ""
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var nameStepCompleted: Bool = false
    @State private var photoStepCompleted: Bool = false
    @State private var makeMethodStepCompleted: Bool = false
    @State private var allStepsCompleted: Bool = false
    @State private var goToIngridientsView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    headerSection
                    textFieldSection
                        .padding(.bottom, 15)
                    Divider()
                    nameAndImageSection
                        .padding(.bottom, 15)
                    Divider()
                    makeMethodsSection
                    Spacer()
                }
                .onAppear {
                    checkIfAllStepsDoneOnAppear()
                }
                .onChange(of: nameStepCompleted, perform: { newValue in
                    checkIfAllStepsDone()
                })
                .onChange(of: selectedPhotoItem) { newValue in
                    if let newValue {
                        viewModel.saveCocktailImage(item: newValue)
                        withAnimation(.easeInOut) {
                            photoStepCompleted.toggle()
                        }
                    }
                    checkIfAllStepsDone()
            }
                .onChange(of: viewModel.selectedMethods, perform: { _ in
                    checkMakeMethodStepIsDone()
                    checkIfAllStepsDone()
                })
                .navigationDestination(isPresented: $goToIngridientsView) {
                    IngridientsView(viewModel: viewModel)
            }
            }
            .background(backgroundImage)
        }
    }
}

struct NameAndImageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NameAndImageView()
        }
    }
}

extension NameAndImageView {
    
    //MARK: - Properties
    
    private var backgroundImage: some View {
        Image("creationBackgroundFirst")
            .resizable()
            .scaledToFill()
            .opacity(0.25)
            .blur(radius: 5)
    }
    
    private var headerSection: some View {
        HStack {
            Spacer()
            Text("Name and Image")
                .font(.title)
            Spacer()
            ArrowButton(goToAnotherView: $goToIngridientsView,
                        allStepsCompleted: $allStepsCompleted,
                        iconName: "arrow.right")
            .disabled(allStepsCompleted ? false : true)
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
    
    private var textFieldSection: some View {
        HStack {
            VStack {
                ReusableTextField(placeHolderTitle: "Type a cocktail name...", searchText: $textFieldText)
                Button {
                    withAnimation(.easeInOut) {
                        checkIfNameIsDone()
                    }
                } label: {
                    Text(nameStepCompleted ? "Rename" : "Add")
                        .font(.title3)
                        .frame(width: 250)
                        .frame(height: 55)
                        .foregroundColor(Color.theme.accent)
                        .background(Color.theme.background)
                        .cornerRadius(25)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, y: 3)
                }
                
            }
            CompletionCircle(stepCompleted: $nameStepCompleted)
        }

    }
    
    private var nameAndImageSection: some View {
        HStack {
            VStack {
                nameStepCompleted ?
                HStack {
                    Text(cocktailName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color.theme.accent)
                        .padding(.horizontal)
                        .padding(.top)
                }
                :
                HStack {
                    Text("Here will be cocktail name")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                Spacer()

                if let cocktailImage = viewModel.customCocktailImage {
                    ZStack {
                        Image(uiImage: cocktailImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.3), radius: 3, y: 3)
                    }
                } else {
                    ZStack {
                        Text("Here will be cocktail image")
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                            .padding(.top)
                            .frame(width: 150, height: 150)
                            .cornerRadius(25)
                    }
                    .frame(width: 150, height: 150)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(25)
                    
                }
                PhotosPicker(selection: $selectedPhotoItem,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Text("Select")
                        .font(.title2)
                        .frame(width: 250)
                        .frame(height: 55)
                        .foregroundColor(Color.theme.accent)
                        .background(Color.theme.background)
                        .cornerRadius(25)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.3), radius: 3, y: 3)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
            CompletionCircle(stepCompleted: $photoStepCompleted)

        }
        .frame(height: 300)
    }
    
    private var makeMethodsSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("Select Make Methods")
                    .font(.title2)
                MakeMethods(selectedMethods: $viewModel.selectedMethods)
            }
            CompletionCircle(stepCompleted: $makeMethodStepCompleted)
        }
    }
    
    //MARK: - Methods
    
    func checkIfNameIsDone() {
        if !textFieldText.isEmpty {
            cocktailName = textFieldText
            viewModel.customCocktailtitle = cocktailName
            nameStepCompleted = true
        } else {
            viewModel.customCocktailtitle = nil
            nameStepCompleted = false
        }
    }
    
    func checkMakeMethodStepIsDone() {
        if !viewModel.selectedMethods.isEmpty {
            withAnimation(.easeInOut) {
                makeMethodStepCompleted = true
            }
        } else {
            withAnimation(.easeInOut) {
                makeMethodStepCompleted = false
            }
        }
    }
    
    func checkIfAllStepsDone() {
        if nameStepCompleted && photoStepCompleted && makeMethodStepCompleted {
            withAnimation(.easeInOut(duration: 0.5).delay(0.1)) {
                allStepsCompleted = true
            }
        } else if !nameStepCompleted || !photoStepCompleted || !makeMethodStepCompleted {
            withAnimation(.easeInOut(duration: 0.5).delay(0.1)) {
                allStepsCompleted = false
            }
        }
    }
    
    func checkIfAllStepsDoneOnAppear() {
        if nameStepCompleted && photoStepCompleted && makeMethodStepCompleted {
                allStepsCompleted = true
        } else if !nameStepCompleted || !photoStepCompleted || !makeMethodStepCompleted {
                allStepsCompleted = false
        }
    }
    
}
