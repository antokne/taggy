//
//  AGWelcomeView.swift
//  Taggy
//
//  Created by Antony Gardiner on 10/05/23.
//

import SwiftUI

struct AGWelcomeView: View {
	var body: some View {
		
		VStack {
			
			Text("Taggy")
				.font(.title)
				.padding(10)
			
			Text("In order for Taggy to work it needs full access to disk. Even though it only reads one file.")
				.padding(5)
			Text("Please open setting and go into Pravicy & Security, Full Disk Access, and enable for Taggy.")
			
			Image("fulldisk access")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: 551, height: 338)
			
			Text("Note that the Find My App needs to be running whilst collecting location information.")
				.font(.title3.bold().italic())
		}
		.padding()
	}
}

struct AGWelcomeView_Previews: PreviewProvider {
	static var previews: some View {
		AGWelcomeView()
	}
}
