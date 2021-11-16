//
//  AddFriendView.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/14/21.
//

import SwiftUI

struct AddFriendView: View {
	@ObservedObject var friendModel: FriendModel
	@ObservedObject var placeModel: PlaceModel
	@Binding var isPresented: Bool
	
	@State var name = ""
	@State var lastName = ""
	@State var friends = [Friend]()
	@State var selection = Set<UUID>()
	
	func dismiss() {
		let friends = friendModel.getFriends(from: selection)
		placeModel.addFriends(friends: friends)
		placeModel.writeToDb()
//		friendModel.share(location: location, with: selection)
		self.isPresented = false
	}
	
	func addNewFriend() {
		let friend = Friend(name: name, lastName: lastName)
		friendModel.addNewFriend(friend)
		clearData()
	}
	
	func clearData() {
		name = ""
		lastName = ""
	}
	
	func delete(at offsets: IndexSet) {
		friendModel.delete(at: offsets)
	}
	
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: .top) {
				List(selection: $selection) {
					ForEach(friendModel.friends) { friend in
						Text(friend.fullName)
					}
					.onDelete(perform: delete)
				}
				.listStyle(InsetGroupedListStyle())
				.navigationTitle("Friends")
				.environment(\.editMode, .constant(.active))
				.toolbar {
					Button("Save", action: dismiss)
						.disabled(selection.isEmpty)
				}
				
				Form {
					TextField("First Name", text: $name)
					TextField("Last Name", text: $lastName)
					Button("Add New Friend", action: addNewFriend)
				}
//				.frame(height: 300)
				.clipShape(RoundedRectangle(cornerRadius: 25))
				.offset(
					x: 0,
					y: geometry.size.height - 200
				)
				.shadow(radius: 10)
			}
		}
	}
}

struct AddFriendView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			AddFriendView(friendModel: FriendModel(friends: testFriends), placeModel: PlaceModel(), isPresented: .constant(true))
				.preferredColorScheme(.dark)
		}
    }
}
