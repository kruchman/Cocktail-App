//
//  IngridientsView.swift
//  CocktailsApp
//
//  Created by Юрий Кручинин on 24/2/24.
//

import SwiftUI

struct IngridientsView: View {
    
    private let glassTypes: [String] = ["cocktail_glass", "collins", "harricane", "high_ball", "irish_glass", "old_fashion", "wine_glass", "shot"]
    let hardnessOptions: [String] = ["easy", "medium", "hard"]
    
    @ObservedObject var viewModel: CustomCocktailsViewModel
    @State private var amountViewIsPresented: Bool = false
    @State private var selectedIngridient: Ingridient?
    @State private var ingridientsStepCompleted: Bool = false
    @State private var selectedGlassType: String?
    @State private var glassStepCompleted: Bool = false
    @State private var hardnessSelection: String = "medium"
    @State private var hardnessStepCompleted: Bool = true
    @State private var goToLastView: Bool = false
    @State private var allStepsCompleted: Bool = false
    
    init(viewModel: CustomCocktailsViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    headerSection
                    ingridientsSection
                    Divider()
                    VStack {
                        selectedIngridientsHeaderSection
                        if ingridientsStepCompleted {
                            selectedIngridientsSection
                        } else {
                            selectedIngridientsPlaceholder
                        }
                    }
                    .padding(.top, 30)
                    Divider()
                    VStack {
                        glassTypeHeaderSection
                        glassTypeSection
                    }
                    Divider()
                    difficultySection
                    Spacer()
                }
                .onAppear {
                    checkIfAllStepsCompleted()
                    viewModel.difficulty = hardnessSelection
                }
                .onChange(of: hardnessSelection, perform: { newValue in
                    viewModel.difficulty = newValue
                })
                .onChange(of: ingridientsStepCompleted, perform: { _ in
                    checkIfAllStepsCompleted()
                })
                .onChange(of: glassStepCompleted, perform: { _ in
                    checkIfAllStepsCompleted()
                })
                .onChange(of: viewModel.selectedIngridients) { _ in
                    if !viewModel.selectedIngridients.isEmpty {
                        withAnimation(.easeInOut) {
                            ingridientsStepCompleted = true
                        }
                    } else if viewModel.selectedIngridients.isEmpty {
                        ingridientsStepCompleted = false
                    }
            }
            }
            if amountViewIsPresented {
                if let selectedIngridient {
                    IngridientAmountView(ingridient: selectedIngridient,
                                         amountViewIsPresented: $amountViewIsPresented,
                                         viewModel: viewModel)
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .trailing),
                                                         removal: .move(edge: .leading)))
                }
            }
        }
        .background(backgroundImage)
    }
}

struct IngridientsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            IngridientsView(viewModel: CustomCocktailsViewModel(firestoreManager: FirestoreManager(),
                                                                coreDataManager: CoreDataManager()))
        }
    }
}

extension IngridientsView {
    
    //MARK: - Properties
    
    private var backgroundImage: some View {
        Image("creationBackgroundSecond")
            .resizable()
            .scaledToFill()
            .opacity(0.25)
            .blur(radius: 5)
    }
    
    private var headerSection: some View {
        HStack {
            Text("Add Some Ingridients")
                .font(.title2)
            Spacer()
            ArrowButton(goToAnotherView: $goToLastView,
                        allStepsCompleted: $allStepsCompleted,
                        viewModel: viewModel,
                        iconName: "checkmark")
            .disabled(allStepsCompleted ? false : true)
        }
        .padding(.horizontal, 30)
        .padding(.top)
    }
    
    private var ingridientsSection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(viewModel.ingridients) { ingridient in
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 80, height: 80)
                                .foregroundColor(ifSelectedIngridientsContains(ingridient) ? Color.theme.green : Color.clear)
                                .blur(radius: 5)
                            ImageServiceView(ingridient: ingridient)
                                .frame(width: 80, height: 80)
                                .clipped()
                                .cornerRadius(20)
                                .shadow(radius: 5, y: 5)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedIngridient = ingridient
                                    }
                                    withAnimation(.easeInOut.speed(1.5)) {
                                        amountViewIsPresented.toggle()
                                    }
                                }
                        }
                        Text(ingridient.title ?? "")
                            .font(.callout)
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding()
        }
    }
    
    private var selectedIngridientsHeaderSection: some View {
        HStack {
            Text("Selected Ingridients")
                .font(.title2)
            Spacer()
            CompletionCircle(stepCompleted: $ingridientsStepCompleted)
        }
        .padding(.horizontal, 30)
    }
    
    private var selectedIngridientsSection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(viewModel.selectedIngridients) { ingridient in
                    VStack {
                        ImageServiceView(ingridient: ingridient)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(20)
                            .shadow(radius: 5, y: 5)
                            .overlay(
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .padding(3)
                                    .background(Circle().fill(Color.gray.opacity(0.3)))
                                    .padding(5)
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            removeIngridientFromSelected(ingridient: ingridient)
                                        }
                                    }
                                , alignment: .topLeading
                            )
                        Text(ingridient.title ?? "")
                            .font(.callout)
                            .fontWeight(.medium)
                        Text("\(ingridient.amount ?? 0) ml/gr")
                            .font(.caption)
                    }
                }
            }
//            .frame(width: 300, height: 150)
            .padding()
        }
    }
    
    private var selectedIngridientsPlaceholder: some View {
        VStack {
            Text("No selected ingridients yet")
                .font(.title3)
        }
        .frame(width: 300, height: 130)
    }
    
    private var glassTypeHeaderSection: some View {
        HStack {
            Text("Select a Glass Type")
                .font(.title2)
            Spacer()
            CompletionCircle(stepCompleted: $glassStepCompleted)
        }
        .padding(.horizontal, 30)
    }
    
    private var glassTypeSection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(glassTypes, id: \.self) { glassType in
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 80, height: 80)
                            .foregroundColor(glassType == viewModel.selectedGlassType ? Color.theme.green : Color.clear)
                            .blur(radius: 5)
                        Image(glassType)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .cornerRadius(20)
                            .shadow(radius: 5, y: 5)
                            .onTapGesture {
                                selectOrUnselectGlassType(glassType: glassType)
                            }
                    }
                }
            }
            .padding()
        }
    }
    
    private var difficultySection: some View {
        VStack {
            HStack {
                Text("Difficulty")
                    .font(.title2)
                Spacer()
                CompletionCircle(stepCompleted: $hardnessStepCompleted)
            }
            .padding(.horizontal, 30)
            Picker("Hardness", selection: $hardnessSelection) {
                ForEach(hardnessOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
    
    //MARK: - Methods
    
    @MainActor
    func removeIngridientFromSelected(ingridient: Ingridient) {
        viewModel.selectedIngridients.removeAll(where: { $0.id == ingridient.id })
        if viewModel.selectedIngridients.isEmpty {
            withAnimation(.easeInOut) {
                ingridientsStepCompleted = false
            }
        }
    }
    
    func ifSelectedIngridientsContains(_ ingridient: Ingridient) -> Bool {
        var result: Bool = false
        for selectedIngridient in viewModel.selectedIngridients {
            if ingridient.id == selectedIngridient.id {
                result = true
                break
            } else {
                result = false
            }
        }
        return result
    }
    
    func selectOrUnselectGlassType(glassType: String) {
        if viewModel.selectedGlassType == nil || viewModel.selectedGlassType != glassType {
            withAnimation(.easeInOut) {
                viewModel.selectedGlassType = glassType
                glassStepCompleted = true
            }
        } else {
            withAnimation(.easeInOut) {
                viewModel.selectedGlassType = nil
                glassStepCompleted = false
            }
        }
    }
    
    func checkIfAllStepsCompleted() {
        if ingridientsStepCompleted && glassStepCompleted {
            withAnimation(.easeInOut) {
                allStepsCompleted = true
            }
        } else {
            withAnimation(.easeInOut) {
                allStepsCompleted = false
            }
        }
    }
}
