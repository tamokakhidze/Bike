//
//  FirestoreService.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 11.07.24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FirestoreFetchable {
    func fetchDocumentData<T: Decodable>(from documentRef: DocumentReference, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func fetchCollectionData<T: Decodable>(from collectionRef: CollectionReference, as type: T.Type, completion: @escaping (Result<[T], Error>) -> Void)
    func uploadData<T: Encodable>(_ data: T, to collectionRef: CollectionReference, completion: @escaping (Result<Void, Error>) -> Void)
}

final class FirestoreService: FirestoreFetchable {
    
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func fetchDocumentData<T: Decodable>(from documentRef: DocumentReference, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        documentRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
                return
            }
            
            do {
                var decodedData = try Firestore.Decoder().decode(T.self, from: document.data() ?? [:])

                if let userInfo = decodedData as? UserInfo {
                    decodedData = UserInfo(documentID: userInfo.documentID,
                                           username: userInfo.username,
                                           currentRentals: userInfo.currentRentals,
                                           points: userInfo.points) as! T
                    
                }
                
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchCollectionData<T: Decodable>(from collectionRef: CollectionReference, as type: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        collectionRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                print(snapshot)
                print(error)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found"])))
                
                return
            }
            
            do {
                let data = try documents.map { try $0.data(as: T.self) }
                completion(.success(data))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func uploadData<T: Encodable>(_ data: T, to collectionRef: CollectionReference, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            _ = try collectionRef.addDocument(from: data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
