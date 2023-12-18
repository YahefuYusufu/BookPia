//
//  BooksViewModel.swift
//  BookPia
//
//  Created by yusufyakuf on 2023-12-15.
//

import Foundation
import Combine
import FirebaseFirestore

class BooksViewModel: ObservableObject {
   @Published var books = [Book]()
   
   private var db = Firestore.firestore()
   private var listenerRegistration: ListenerRegistration?
   
   deinit {
      unsubscribe()
   }
   
   func unsubscribe() {
      if listenerRegistration != nil {
         listenerRegistration?.remove()
         listenerRegistration = nil
      }
   }
   
   func subscribe() {
      if listenerRegistration == nil {
         listenerRegistration = db.collection("books").addSnapshotListener { (QuerySnapshot, error) in
            guard let documents = QuerySnapshot?.documents else {
               print("No Documents")
               return
            }
            self.books = documents.compactMap { QueryDocumentSnapshot in
               try? QueryDocumentSnapshot.data(as: Book.self)
            }
         }
      }
   }
   
   func removeBooks(atOffsets indexSet: IndexSet) {
      let books = indexSet.lazy.map { self.books[$0]}
      books.forEach { book in
         if let documentId = book.id {
            db.collection("books").document(documentId).delete { error in
               if let error = error {
                  print("Unable to remove document: \(error.localizedDescription)")
               }
            }
         }
      }
   }
}


 
