//
//  Database.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/15/21.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
	case OpenDatabase(message: String)
	case Prepare(message: String)
	case Step(message: String)
	case Bind(message: String)
}

/// A wrapper around `SQLite` database for easy access
//class SQLiteDatabase {
//
//	// MARK: - Init
//
//	private let dbPointer: OpaquePointer?
//	private init(dbPointer: OpaquePointer?) {
//		self.dbPointer = dbPointer
//	}
//	deinit {
//		sqlite3_close(dbPointer)
//	}
//
//	// MARK: - Variables
//
//	/// A computed property, which simply returns the most recent error `SQLite` knows about.
//	fileprivate var errorMessage: String {
//		if let errorPointer = sqlite3_errmsg(dbPointer) {
//			let errorMessage = String(cString: errorPointer)
//			return errorMessage
//		} else {
//			return "No error message provided from sqlite."
//		}
//	}
//
//	// MARK: - Methods
//
//	/// Use this to open a database with a path
//	static func open(path: String) throws -> SQLiteDatabase {
//		var db: OpaquePointer?
//
//		// Open the database at the provided path
//		if sqlite3_open(path, &db) == SQLITE_OK {
//			// Return a db
//			return SQLiteDatabase(dbPointer: db)
//		} else {
//			// Or throw an error
//			defer {
//				if db != nil {
//					sqlite3_close(db)
//				}
//			}
//			if let errorPointer = sqlite3_errmsg(db) {
//				let message = String(cString: errorPointer)
//				throw SQLiteError.OpenDatabase(message: message)
//			} else {
//				throw SQLiteError
//				.OpenDatabase(message: "No error message provided from sqlite.")
//			}
//		}
//	}
//}

// MARK: - Database Queries
//
//extension SQLiteDatabase {
//	/// Compiles the SQL statement into byte code and returns a status code
//	func prepareStatement(sql: String) throws -> OpaquePointer? {
//		var statement: OpaquePointer?
//		guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil)
//				== SQLITE_OK else {
//			throw SQLiteError.Prepare(message: errorMessage)
//		}
//		return statement
//	}
//
//	/// Method that accepts types that conform to `SQLTable` to create a table
//	func createTable(table: SQLTable.Type) throws {
//		// 1
//		let createTableStatement = try prepareStatement(sql: table.createStatement)
//		// 2
//		defer {
//			sqlite3_finalize(createTableStatement)
//		}
//		// 3
//		guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
//			throw SQLiteError.Step(message: errorMessage)
//		}
//		print("\(table) table created.")
//	}
//
//	// MARK: - Insertion
//
//	/// Inserts a `Friend` into database
//	func insertFriend(friend: Friend) throws {
//		let insertSql = "INSERT INTO Friends (id, name, lastName) VALUES (?, ?, ?);"
//		let insertStatement = try prepareStatement(sql: insertSql)
//		defer {
//			sqlite3_finalize(insertStatement)
//		}
//		let id: NSString = friend.id.uuidString as NSString
//		let name: NSString = friend.name as NSString
//		let lastName: NSString = friend.lastName as NSString
//		guard
//			sqlite3_bind_text(insertStatement, 1, id.utf8String, -1, nil) == SQLITE_OK  &&
//				sqlite3_bind_text(insertStatement, 2, name.utf8String, -1, nil)
//				== SQLITE_OK &&
//				sqlite3_bind_text(insertStatement, 3, lastName.utf8String, -1, nil)
//				== SQLITE_OK
//		else {
//			throw SQLiteError.Bind(message: errorMessage)
//		}
//		guard sqlite3_step(insertStatement) == SQLITE_DONE else {
//			throw SQLiteError.Step(message: errorMessage)
//		}
//		print("Successfully inserted row.")
//	}
//
//	/// Inserts a `Place` into database
//	func insertPlace(place: Place) throws {
//		let insertSql = "INSERT INTO Places (lat, long, friendid) VALUES (?, ?, ?);"
//		let insertStatement = try prepareStatement(sql: insertSql)
//		defer {
//			sqlite3_finalize(insertStatement)
//		}
//		let friendIDs = place.friends.map { ($0.id.uuidString as NSString).utf8String }
//		let lat = place.coordinate.latitude
//		let long = place.coordinate.longitude
////		guard
////			sqlite3_bind_double(insertStatement, 1, lat) == SQLITE_OK &&
////			sqlite3_bind_double(insertStatement, 2, long) == SQLITE_OK
////		else {
////			throw SQLiteError.Bind(message: errorMessage)
////		}
//
//		try friendIDs.forEach { id in
//			guard
//				sqlite3_bind_double(insertStatement, 1, lat) == SQLITE_OK &&
//				sqlite3_bind_double(insertStatement, 2, long) == SQLITE_OK &&
//				sqlite3_bind_text(insertStatement, 3, id, -1, nil) == SQLITE_OK
//			else {
//				throw SQLiteError.Step(message: errorMessage)
//			}
//		}
//
//		guard sqlite3_step(insertStatement) == SQLITE_DONE else {
//			throw SQLiteError.Step(message: errorMessage)
//		}
//		print("Successfully inserted row.")
//	}
	
	// MARK: - Query
	/// Read from database
//	func place(id: UnsafePointer<CChar>?) -> Place? {
//		let querySql = "SELECT * FROM Places WHERE Id = ?;"
//		guard let queryStatement = try? prepareStatement(sql: querySql) else {
//		  return nil
//		}
//		defer {
//		  sqlite3_finalize(queryStatement)
//		}
////		guard sqlite3_bind_int(queryStatement, 1, id) == SQLITE_OK else {
////		  return nil
////		}
//		while sqlite3_step(queryStatement) == SQLITE_ROW {
//			let lat = sqlite3_column_double(queryStatement, 0)
//			let long = sqlite3_column_double(queryStatement, 1)
//			guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
//				print("Query result is nil.")
//				return nil
//			}
//			let friendID = String(cString: queryResultCol2) as NSString
//		}
//
//		return Contact(id: id, name: name)
//	  }
//}

// left join place & friend: lat, long, fid, id, name, lname


protocol SQLTable {
	static var createStatement: String { get }
//	static func fromDb(id: Int32, name: NSString) -> SQLTable
}

//struct Contact {
//	let id: Int32
//	let name: NSString
//}

//extension Contact: SQLTable {
////	static func fromDb(id: Int32, name: NSString) -> SQLTable {
////		return Contact(id: id, name: name)
////	}
//
//	static var createStatement: String {
//		return """
//	CREATE TABLE Contact(
//		id TEXT PRIMARY KEY NOT NULL,
//		name TEXT,
//		lastName TEXT
//	);
//	"""
//	}
//}

// read
//if let first = db.contact(id: 1) {
//	print("\(first.id) \(first.name)")
//}

// insert
//do {
//	try db.insertContact(contact: Contact(id: 1, name: "Ray"))
//} catch {
//	print(db.errorMessage)
//}

// create tabale
//do {
//	try db.createTable(table: Contact.self)
//} catch {
//	print(db.errorMessage)
//}

// create database
//let db: SQLiteDatabase
//do {
//	db = try SQLiteDatabase.open(path: part2DbPath ?? "")
//	print("Successfully opened connection to database.")
//} catch SQLiteError.OpenDatabase(_) {
//	print("Unable to open database.")
//	PlaygroundPage.current.finishExecution()
//}
