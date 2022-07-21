//
//  CurrencyConversionView.swift
//  CurrencyConverter
//
//  Created by Rajiv Verma on 18/07/22.
//

import SwiftUI

struct CurrencyConversionView: View {
    @StateObject var viewModel = CurrencyConversionViewModel()
    @FocusState private var isKeyboardVisible: Bool
    
    
    /// User Form for accepting user input for amount, from and to fields.
    fileprivate func UserForm() -> some View {
        return VStack (alignment: .leading, spacing: 30) {
            VStack (alignment: .leading)  {
                Text(Constants.Labels.amountLabel)
                TextField(Constants.Labels.amountLabel,
                          value: $viewModel.amount, formatter: viewModel.currencyFormatter)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .keyboardType(.numbersAndPunctuation)
                .multilineTextAlignment(.center)
                .background(.thinMaterial)
                .cornerRadius(12)
                .focused($isKeyboardVisible)
                .accessibilityIdentifier("AmountTextField")
            }
            
            VStack (alignment: .leading)  {
                Text(Constants.Labels.fromLabel)
                Picker(Constants.Labels.fromPickerLabel, selection: $viewModel.from) {
                    ForEach(viewModel.currencies, id: \.id) {
                        Text("\($0.code) - \($0.name)")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .accessibilityIdentifier($0.code)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.thinMaterial)
                .cornerRadius(12)
                .accessibilityIdentifier("FromCurrencyPicker")
                
            }
            VStack (alignment: .leading) {
                Text(Constants.Labels.toLabel)
                    .multilineTextAlignment(.leading)
                
                Picker(Constants.Labels.toPickerLabel, selection: $viewModel.to) {
                    ForEach(viewModel.currencies, id: \.id) {
                        Text("\($0.code) - \($0.name)")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                            .accessibilityIdentifier($0.code)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.thinMaterial)
                .cornerRadius(12)
                .accessibilityIdentifier("ToCurrencyPicker")
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 50)
    }
    
    /// ResultView for displaying currency conversion results
    fileprivate func ResultView() -> some View {
        return HStack (alignment: .center) {
            Spacer()
            Text(viewModel.currencyConversionResult)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("ResultText")
            Spacer()
        }.padding(.top, 50)
    }
    
    fileprivate func ConvertButtonView() -> some View {
        return HStack (alignment: .center) {
            Spacer()
            Button(action: {
                isKeyboardVisible = false
                viewModel.convert(amount: viewModel.amount,
                                  from: viewModel.from,
                                  to: viewModel.to)
            }, label : {
                Text(Constants.Labels.convertButtonLabel)
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(.blue)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .cornerRadius(12)
            }).accessibilityIdentifier("ConvertButton")
            Spacer()
        }.padding(.top, 20)
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack {
                        UserForm()
                        ConvertButtonView()
                        
                        // observe for any errors during currency conversion
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                                .accessibilityIdentifier("ErrorText")
                        }
                        
                        ResultView()
                        Spacer()
                    }
                    
                }.navigationTitle(Constants.Labels.navigationHeader)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            
            if viewModel.isLoading {
                ProgressView()
                    .accessibilityIdentifier("ProgressView")
            }
        }.task {
            // start loading currencies for the pickers as soon as the view appears
            viewModel.loadCurrencies()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let mockService = MockedCurrencyConversionService()
        let viewModel = CurrencyConversionViewModel(service: mockService)
        CurrencyConversionView(viewModel: viewModel)
    }
}
