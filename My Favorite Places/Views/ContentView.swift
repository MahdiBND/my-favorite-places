//
//  ContentView.swift
//  My Favorite Places
//
//  Created by Mahdi BND on 11/12/21.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
	@StateObject var placeModel = PlaceModel()
	@StateObject var friendModel = FriendModel()
	
	@State var expandList: Bool = false
	@State var selectedMarker: GMSMarker? = nil
	@State var yDragTranslation: CGFloat = 0
	
	var body: some View {
		let scrollViewHeight: CGFloat = 80
		
		GeometryReader { geometry in
			ZStack(alignment: .top) {
				// Map
				MapView(markers: $placeModel.markers, selectedMarker: $selectedMarker, position: .constant(nil))
				
				// Friends List
				FriendsList(friendModel: friendModel, placeModel: placeModel, handleAction: { self.expandList.toggle() })
					.background(Color.white)
					.clipShape(RoundedRectangle(cornerRadius: 15))
					.offset(
						x: 0,
						y: geometry.size.height - (expandList ? scrollViewHeight + 150 : scrollViewHeight)
					)
					.offset(x: 0, y: self.yDragTranslation)
					.animation(.spring())
					.gesture(
						DragGesture().onChanged { value in
							self.yDragTranslation = value.translation.height
						}.onEnded { value in
							self.expandList = (value.translation.height < -120)
							self.yDragTranslation = 0
						}
					)
					.shadow(radius: 10)
			}
		}
		.onAppear {
			friendModel.readFromDb()
			placeModel.readFromDb()
		}
		.edgesIgnoringSafeArea(.top)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
