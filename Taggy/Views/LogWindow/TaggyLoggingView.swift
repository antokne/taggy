//
//  TaggyLoggingView.swift
//  Taggy
//
//  Created by Antony Gardiner on 16/05/23.
//

import SwiftUI

struct TaggyLoggingView: View {
	@State var textLog: String = ""
	
	@ObservedObject var viewModel: TaggyLoggingViewModel

	var body: some View {
		VStack {
			TextEditor(text: .constant(viewModel.textLog))
				.font(.monospaced(.body)())
				.overlay {
					Text(viewModel.textLog.isEmpty ? "Logs will appear here when enabled." : "")
						.allowsHitTesting(false)
				}
			
		}
		.padding(3)
	}
}

struct TaggyLoggingView_Previews: PreviewProvider {
	static var previews: some View {
		TaggyLoggingView(viewModel: TaggyLoggingViewModel())
	}
}
