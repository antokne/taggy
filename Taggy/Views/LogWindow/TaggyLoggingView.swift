//
//  TaggyLoggingView.swift
//  Taggy
//
//  Created by Antony Gardiner on 16/05/23.
//

import SwiftUI
import SwiftUIIntrospect

struct TaggyLoggingView: View {
	
	@ObservedObject var viewModel: TaggyLoggingViewModel

	var body: some View {
		VStack {
			TextEditor(text: $viewModel.textLog)
				.font(.monospaced(.body)())
				.overlay {
					Text(viewModel.textLog.isEmpty ? "Logs will appear here when enabled." : "")
						.allowsHitTesting(false)
				}
				.introspect(.textEditor, on: .macOS(.v11, .v12, .v13, .v14)) { textEditor in
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
