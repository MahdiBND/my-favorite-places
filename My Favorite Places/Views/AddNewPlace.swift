//
//  AddNewPlace.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/14/21.
//

import SwiftUI
import GoogleMaps

struct AddNewPlace: View {
	@ObservedObject var friendModel: FriendModel
	@ObservedObject var placeModel: PlaceModel
	@Binding var isPresented: Bool
	
	@State var goToNextPage = false
	@State var position: GMSCameraPosition?
	
	var barItem: some View {
		NavigationLink(destination: AddFriendView(friendModel: friendModel, placeModel: placeModel, isPresented: $isPresented),
					   isActive: $goToNextPage) {
			Button("Next", action: proceed)
		}
	}
	
	func proceed() {
		guard let pos = position else {
			return
		}
		let location = pos.target
		placeModel.newPlace = Place(lat: location.latitude, long: location.longitude)
		goToNextPage.toggle()
	}
	
	func dismiss() {
		self.isPresented = false
	}
	
    var body: some View {
		NavigationView {
			ZStack(alignment: .center) {
				MapView(markers: .constant([GMSMarker()]), selectedMarker: .constant(nil), position: $position)
				
				Image("marker")
					.renderingMode(.template)
					.foregroundColor(.pink)
					.font(.caption)
			}
			.navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: barItem)
			.navigationBarTitleDisplayMode(.inline)
			.edgesIgnoringSafeArea(.bottom)
			.navigationTitle("Select Location")
		}
	}
}

struct AddNewPlace_Previews: PreviewProvider {
    static var previews: some View {
		AddNewPlace(friendModel: FriendModel(), placeModel: PlaceModel(), isPresented: .constant(true))
    }
}
