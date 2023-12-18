//
//  ContentView.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct ContentView: View {
   
   @StateObject var viewModel = BooksViewModel()
   @State var presentAddBookSheet = false
   
   
   private var addButton: some View {
      Button(action: { self.presentAddBookSheet.toggle() }) {
         Image(systemName: "plus.app.fill")
      }
   }
   
   private func bookRowView(book: Book) -> some View {
      NavigationLink(destination: BookDetailsView(book: book)) {
         VStack(alignment: .leading) {
            HStack {
               VStack {
                  AnimatedImage(url: URL(string:book.image))
                     .resizable()
                     .frame(width:95,height: 145)
               }
               VStack(alignment: .leading) {
                  Text(book.title)
                     .fontWeight(.bold)
                  Text(book.author)
                     .foregroundStyle(Color.green)
                     .fontWeight(.heavy)
                  Text(book.description)
                     .foregroundStyle(.opacity(0.8))
                     .fontWeight(.light)
               }
               .padding(.horizontal,15)
            }
            .padding(.top,5)
         }
      }
      
   }
   
   var body: some View {
      NavigationView {
         List {
            ForEach (viewModel.books) { book in
               bookRowView(book: book)
            }
            .onDelete() { indexSet in
               viewModel.removeBooks(atOffsets: indexSet)
            }
         }
         .navigationBarTitle("Books")
         .navigationBarTitleDisplayMode(.inline)
         
         .navigationBarItems(trailing: addButton)
         .onAppear() {
            print("BooksListView appears. Subscribing to data updates.")
            self.viewModel.subscribe()
         }
         .sheet(isPresented: self.$presentAddBookSheet) {
            BookEditView()
         }
      }
      Spacer()
   }
}

#Preview {
   ContentView()
}




