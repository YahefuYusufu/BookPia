//
//  BookViewModel.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import Foundation
import Combine
import FirebaseFirestore

class BookViewModel: ObservableObject {
   @Published var book: Book
   @Published var modified = false
   
   private var cancellables = Set<AnyCancellable>()
   
   init(book: Book = Book(author: "", title: "",description: "", numberOfPages: 0, image: "")) {
      self.book = book
      
      self.$book
         .dropFirst()
         .sink { [weak self] book in
            self?.modified = true
         }
         .store(in: &self.cancellables)
   }
   
   private var db = Firestore.firestore()
   
   private func addBook(_ book: Book) {
      do {
         let _ = try db.collection("books").addDocument(from: book)
      } catch {
         print(error)
      }
   }
   
   private func updateBook(_ book: Book) {
      if let documentId = book.id {
         do {
            try db.collection("books").document(documentId).setData(from: book)
         }
         catch {
            print(error)
         }
      }
   }
   
   private func updateOrAddBook() {
      if let _ = book.id {
         self.updateBook(self.book)
      } else {
         addBook(book)
      }
   }
   private func removeBook() {
      if let documentId = book.id {
         db.collection("books").document(documentId).delete() { error in
            if let error = error {
               print(error.localizedDescription)
            }
         }
      }
   }
   func handleDoneTapped() {
      self.updateOrAddBook()
   }
   func handleDeleteTapped() {
      self.removeBook()
   }
}
