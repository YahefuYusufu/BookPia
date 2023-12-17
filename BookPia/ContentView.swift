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
                     .frame(width:65,height: 65)
                     .clipShape(Circle())
               }
               VStack(alignment: .leading) {
                  Text(book.title)
                     .fontWeight(.bold)
                  Text(book.author)
               }
            }
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




