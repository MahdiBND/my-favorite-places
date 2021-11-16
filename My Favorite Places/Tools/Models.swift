//
//  Places.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/13/21.
//

import GoogleMaps
import SwiftUI
import GRDB

// MARK: - Database

class SQLiteDatabase {
	static var path : String = "AppDataBase.sqlite"
	static let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
	
	static let database = try! DatabasePool(path: filePath.path)
}


// MARK: - Places

typealias Location = CLLocationCoordinate2D

struct Place: Hashable, Codable, FetchableRecord, PersistableRecord {
	var lat: Double
	var long: Double
	var friends = [Friend]()
}

class PlaceModel: ObservableObject {
	@Published private var places = [Place]()
	@Published var markers = [GMSMarker]()
	@Published var newPlace: Place?
	
	func set(from friend: Friend) {
		let filteredPlaces = places.filter { $0.friends.contains(friend) }
		markers = filteredPlaces.map { GMSMarker(position: Location(latitude: $0.lat, longitude: $0.long)) }
	}
	
	func addFriends(friends: [Friend]) {
		if var place = newPlace {
			friends.forEach { place.friends.append($0) }
			places.append(place)
		}
	}
	
	func readFromDb() {
		guard let placeList =
				try? SQLiteDatabase.database.read({ try Place.fetchAll($0) })
		else { return }
		
		places = placeList
	}
	
	func writeToDb() {
		try? SQLiteDatabase.database.write { db in
			if try db.tableExists("place") {
				try places.forEach { try $0.insert(db) }
			} else {
				try db.create(table: "place") { t in
					t.column("lat", .double).notNull()
					t.column("long", .double).notNull()
					t.column("friends", .blob)
				}
				
				try places.forEach { try $0.insert(db) }
			}
		}
	}
}


// MARK: - People

/// `Friend`'s Model
struct Friend: Identifiable, Hashable,
			   Codable, FetchableRecord, PersistableRecord {
	var id = UUID()
	var name: String
	var lastName: String
	
	var fullName: String {
		return "\(name) \(lastName)"
	}
}

/// `Friend`'s View Model
class FriendModel: ObservableObject {
	@Published var friends = [Friend]()
	
	func addNewFriend(_ friend: Friend) {
		self.friends.append(friend)
		writeToDb(friend: friend)
	}
	
	init(friends: [Friend] = []) {
		self.friends = friends
	}
	
	func delete(at offsets: IndexSet) {
		friends.remove(atOffsets: offsets)
	}
	
	func getFriends(from ids: Set<UUID>) -> [Friend] {
		friends.filter { ids.contains($0.id) }
	}
	
	func readFromDb() {
		guard let friendList =
				try? SQLiteDatabase.database.read({ try Friend.fetchAll($0) })
		else { return }
		
		friends = friendList
	}
	
	private func removeFromDb(friend: Friend) {
		_ = try? SQLiteDatabase.database.write { db in
			try friend.delete(db)
		}
	}
	
	private func writeToDb(friend: Friend) {
		try? SQLiteDatabase.database.write { db in
			if try db.tableExists("friend") {
				try friend.insert(db)
			} else {
				try db.create(table: "friend") { t in
					t.column("id", .text).notNull()
					t.column("name", .text).notNull()
					t.column("lastName", .text).notNull()
				}
				
				try friend.insert(db)
			}
		}
	}
}


// MARK: - Test Data

let sara = Friend(name: "Sara", lastName: "Rad")
let farhad = Friend(name: "Farhad", lastName: "Jems")

let testFriends = [sara, farhad]

let places1 = [
	Place(lat: 37.7576, long: -122.4194),
	Place(lat: 47.6131742, long: -122.4824903),
	Place(lat: 35.3440852, long: 120.6836164),
	Place(lat: 33.8473552, long: 120.6511076),
	Place(lat: 35.6684411, long: 110.6004407)
]
