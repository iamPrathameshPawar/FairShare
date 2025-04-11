//
//  ContentView.swift
//  WeSplit
//
//  Created by Prathamesh Pawar on 4/4/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @State private var isPreviewOn: Bool = false
    
    @FocusState private var amountIsFocused: Bool
        
    var splitAmount: Double {
        let peopleCount = Double(numberOfPeople)
        let tipSelected = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelected
        let grandTotal = checkAmount + tipValue
        
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack{
            ZStack {
                
                Color(.systemYellow)
                    .ignoresSafeArea()
                
                Form{
                    Section{
                        TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                    }
                    .listRowBackground(Color.cyan)
                    
                    Section("Split the check in") {
                        Picker("Number of People", selection: $numberOfPeople) {
                            ForEach(0..<101){
                                Text("\($0) People")
                            }
                        }
                    }
                    
                    Section{
                        HStack{
                            Text("Check Amount: ")
                            Spacer()
                            Text(checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                    
                    Section("How much do you want to Tip?"){
                        Picker("", selection: $tipPercentage){
                            ForEach(tipPercentages, id: \.self){
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.green)
                    
                    Section("Calculation: "){
                        Text("Check Amount = \(checkAmount)")
                        Text("After \(tipPercentage) % of tip = \((checkAmount / 100 * Double(tipPercentage)) + checkAmount)")
                        Text("Total amount divided into \(numberOfPeople) People = \(splitAmount)")
                    }
                    
                    Section{
                        HStack{
                            Text("Split Amount: ")
                            Spacer()
                            Text(splitAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                        .listRowBackground(Color.mint)
                    }
                    
                    HStack {
                        Button("Show My Share") {
                            isPreviewOn.toggle()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.clear)
                    .listRowBackground(Color.clear)

                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("FairShare")
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
            .sheet(isPresented: $isPreviewOn) {
                MyShareView(isPreviewOn: $isPreviewOn, myCheckAmount: .constant(splitAmount))
                    .presentationDetents([.medium])
            }
        }
    }
}

struct MyShareView: View {
    @Binding var isPreviewOn: Bool
    @Binding var myCheckAmount: Double
    
    var body: some View {
        Spacer()
        Text("Your Share: \(myCheckAmount)")
        Spacer()
        Button("Dismiss"){
            isPreviewOn.toggle()
        }
        
        .onAppear(){
            print("Appeared")
        }
        
        .onDisappear(){
            print("Disappeared")
        }
    }
}

#Preview {
    ContentView()
}
