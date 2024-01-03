//
//  BookEditView.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import SwiftUI
import PhotosUI

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
   @State private var profileImage: UIImage?
   @State private var photoPickerItem: PhotosPickerItem?
   
   
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
         VStack {
            Form {
               Section(header: Text("Book")) {
                  TextField("Titte",text: $viewModel.book.title)
                  TextField("Number of pages",value: $viewModel.book.numberOfPages,formatter: NumberFormatter())
               }
               Section(header: Text("Author&Description")) {
                  TextField("Author",text: $viewModel.book.author)
                  TextField("Description",text: $viewModel.book.description)
               }
               
               Section(header: Text("Photo")) {
                  TextField("Image Link",text: $viewModel.book.image)
               }
               VStack {
                  HStack(alignment: .center) {
                     PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        Image(uiImage: (profileImage ?? UIImage(systemName: "photo"))!)
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width:30,height: 50)

                     }
                  }
               }

               if mode == .edit {
                  Section {
                     Button("Delete book") { self.presentActionSheet.toggle()}
                        .foregroundColor(.red)
                  }
               }
            }
           
         }
         .onChange(of: photoPickerItem) { _,_ in
            Task {
               if let photoPickerItem,
                  let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                  if let image = UIImage(data: data) {
                     profileImage = image
                  }
               }
               photoPickerItem = nil
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
