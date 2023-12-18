//
//  BookDetailsView.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import SwiftUI
import SDWebImageSwiftUI


struct BookDetailsView: View {
   @Environment(\.presentationMode) var presentationMode
   @State var presentEditBookSheet = false
   var book : Book
   
   private func editButton(action: @escaping () -> Void) -> some View {
      Button(action: {
         action()
      }) {
         Text("Edit")
      }
   }
   
   var body: some View {
      Form {
            Section(header: Text("Book Name")) {
               Text(book.title)
               
               Text("\(book.numberOfPages) pages")
            }
            
            Section(header: Text("Author & Description")) {
               Text(book.author)
               Text(book.description)
                  .frame(height: 50)
            }
            Section(header: Text("Photo")) {
               AnimatedImage(url: URL(string: book.image)).resizable().frame(width: 300,height: 300)
            }
         }
         .navigationBarTitle(book.title)
         .navigationBarItems(trailing: editButton {
            self.presentEditBookSheet.toggle()
         })
         .onAppear() {
            print("BookdDetailsView.onAppear() for \(self.book.title)")
         }
         .sheet(isPresented: self.$presentEditBookSheet) {
            BookEditView(viewModel: BookViewModel(book: book),mode: .edit) { result in
               if case .success(let action) = result, action == .delete {
                  self.presentationMode.wrappedValue.dismiss()
               }
            }
         }
      }
   }

struct BookDetailsView_Previews: PreviewProvider {
   static var previews: some View {
      let book = Book(author: "Cairocoders", title: "Coder", description: "book description", numberOfPages: 23, image: "photo1")
     
      NavigationView {
         BookDetailsView(book: book)
      }
   }
}
