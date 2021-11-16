//
//  AddViewManager.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/14/21.
//

import SwiftUI

struct AddViewManager: View {
	@ObservedObject var friendModel: FriendModel
	@ObservedObject var placeModel: PlaceModel
	
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddViewManager_Previews: PreviewProvider {
    static var previews: some View {
		AddViewManager(friendModel: FriendModel(), placeModel: PlaceModel())
    }
}
