//
//  FirendsList.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/13/21.
//

import SwiftUI
import GoogleMaps

struct FriendsList: View {
	@ObservedObject var friendModel: FriendModel
	@ObservedObject var placeModel: PlaceModel
	
	@State var showAddNewPlace = false
	
	var handleAction: () -> Void
	
	// MARK: - Methods
	
	func onTap(_ friend: Friend) {
		placeModel.set(from: friend)
	}
	
	func onDismiss() {
		if let firstFriend = friendModel.friends.first {
			placeModel.set(from: firstFriend)
		}
	}
	
	var body: some View {
		GeometryReader { geometry in
			VStack(spacing: 0) {
				
				// List Handle
				HStack(alignment: .center) {
					Rectangle()
						.frame(width: 35, height: 5, alignment: .center)
						.cornerRadius(10)
						.opacity(0.25)
						.padding(.vertical, 8)
				}
				.frame(width: geometry.size.width, height: 20, alignment: .center)
				
				.onTapGesture {
					handleAction()
				}
				
				// List of Friends
				ZStack(alignment: .topTrailing ) {
					List(friendModel.friends) { friend in
						Button(action: { onTap(friend) }) {
							Text(friend.fullName)
						}
					}
					.frame(maxWidth: .infinity)
					
					Button(action: { showAddNewPlace.toggle() }) {
						Image(systemName: "plus")
							.font(.title)
							.padding(12)
							.background(Color(UIColor.systemBackground))
							.cornerRadius(15)
							.shadow(color: .secondary, radius: 5)
							.padding()
					}
					.fullScreenCover(isPresented: $showAddNewPlace, onDismiss: onDismiss) {
						AddNewPlace(friendModel: friendModel, placeModel: placeModel, isPresented: $showAddNewPlace)
					}
					
				}
			}
		}
	}
}

struct FriendList_Previews: PreviewProvider {
	static var previews: some View {
		FriendsList(friendModel: FriendModel(), placeModel: PlaceModel(), handleAction: {})
			.preferredColorScheme(.dark)
	}
}
