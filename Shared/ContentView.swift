//
//  ContentView.swift
//  Shared
//
//  Created by Kole Titanovski on 25.1.25.
//

import SwiftUI
import Contacts
import MessageUI
import Foundation

struct ContentView: View {
    @State private var showAlert = false
    @State private var storedPhoneNumber: String = UserDefaults.standard.string(forKey: "savedPhoneNumber") ?? ""
    @State private var newPhoneNumber: String = ""
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue.opacity(0.6)]),
                                   startPoint: .top,
                                   endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)

                    VStack() {
                        if storedPhoneNumber.isEmpty {
                            FancyButton(title: "Find your Colé", action: requestPermission).offset(x:0,y:-60)
                        } else {
                            Text("Colé is probably:\n \(DetermineVerb())")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .offset(x:0,y:-60)

                            FancyButton(title: "Summoning", action: sendMessage)
                            
                        }
                    }
                    .padding()
                }
            }



    func requestPermission()
    {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) {granted, error in
            if granted { searchForContact() }
            else { print("Permission Denied :(") }
            
        }
    }

    func searchForContact()
    {
        let store = CNContactStore()
        let request = CNContactFetchRequest(keysToFetch: [CNContactPhoneNumbersKey as CNKeyDescriptor])
        let searchQuery: String = "94411"
        do{
            try store.enumerateContacts(with: request) {contact, stop in
                
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value.stringValue
                    if phoneNumber.contains(searchQuery) {

                        DispatchQueue.main.async {
                            storedPhoneNumber = phoneNumber
                            UserDefaults.standard.setValue(phoneNumber, forKey: "savedPhoneNumber")
                        }
                        stop.pointee = true
                        return
                    }
                }

            }
            
        }
        
        catch{
            print("Error")
        }
        
        
    }
    
    func sendMessage()
    {

        guard let smsURL = URL(string: "sms:\(storedPhoneNumber)&body=Dota ?")
        
        else {
            print ("Message was not sent")
            return
        }
        UIApplication.shared.open(smsURL)    }
    
    
    func DetermineVerb() -> String
    {
        let Verbs = ["Sleeping", "Daydreaming", "Listening to music", "Swifting", "Reading", "Working on Project Brutality", "Gaming"]
        let currentHour = Calendar.current.component(.hour, from: Date())
        var availableItems: [String] = []

        if currentHour >= 6 && currentHour < 12 {
            availableItems = [Verbs[0]]
        } else if currentHour >= 12 && currentHour < 14 {
            availableItems = [Verbs[1], Verbs[2]]
        }
        else if currentHour >= 14 && currentHour < 17 {
            availableItems = [Verbs[1], Verbs[3], Verbs[4]]
        }
        else {
            availableItems = [Verbs[5], Verbs[6]]
        }

        let selectedItem = availableItems.randomElement()

        if let item = selectedItem {
            return item
        } else {
            return ""
        }
    }


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .padding()
                .frame(width: nil)
        }
    }

}

struct FancyButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.gray]),
                                           startPoint: .center,
                                           endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(60)
                .shadow(color: Color.blue.opacity(0.6), radius: 10, x: 0, y: 4) // Glow effect
        }
        .padding(.horizontal, 40)
    }
}
