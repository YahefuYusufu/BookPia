//
//  BookEditView.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import SwiftUI

enum Mode {
   case new
   case edit
}
enum Action {
   case delete
   case done
   case cancel
}

struct BookEditView: View {
   
   @Environment(\.presentationMode) private var presentationMode
   @State var presentActionSheet = false
   @ObservedObject var viewModel = BookViewModel()
   var mode: Mode = .new
   var completionHandler: ((Result<Action, Error>) -> Void )?
   @State var shouldShowImagePicker = false
   
   
   var cancelButton: some View {
      Button(action: { self.handleCancelTapped()}){
         Text("Cancel")
      }
   }
   
   var saveButton: some View {
      Button(action: { self.handleDoneTapped()}){
         Text(mode == .new ? "Done" : "Save")
      }
      .disabled(!viewModel.modified)
   }
   
   var body: some View {
      NavigationView {
         Form {
            Section(header: Text("Book")) {
               TextField("Titte",text: $viewModel.book.title)
               TextField("Number of pages",value: $viewModel.book.numberOfPages,formatter: NumberFormatter())
            }
            
            Section(header: Text("Author")) {
               TextField("Author",text: $viewModel.book.author)
            }
            
            Section(header: Text("Photo")) {
               TextField("Image",text: $viewModel.book.image)
          
            }
            
            if mode == .edit {
               Section {
                  Button("Delete book") { self.presentActionSheet.toggle()}
                     .foregroundColor(.red)
               }
            }
         }
         .navigationTitle(mode == .new ? "New Book" : viewModel.book.title)
         .navigationBarTitleDisplayMode(mode == .new ? .inline : .large)
         .navigationBarItems(
            leading: cancelButton,
            trailing: saveButton
         )
         .actionSheet(isPresented: $presentActionSheet) {
            ActionSheet(title: Text("Are you sure?"),
                        buttons: [
                           .destructive(Text("Delete book"),
                                        action:{ self.handleDeleteTappad()}),
                           .cancel()
                        ])
         }
      }
   }
   
   
   
   func handleCancelTapped() {
      self.dismiss()
   }
   
   func handleDoneTapped() {
      self.viewModel.handleDoneTapped()
      self.dismiss()
   }
   func handleDeleteTappad() {
      viewModel.handleDeleteTapped()
      self.dismiss()
      self.completionHandler?(.success(.delete))
   }
   func dismiss() {
      self.presentationMode.wrappedValue.dismiss()
   }
}

#Preview {
   BookEditView()
}
