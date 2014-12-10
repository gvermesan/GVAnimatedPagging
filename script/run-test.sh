#!/bin/sh

xcodebuild \
	-project GVAnimatedPagging.xcodeproj \
	-sdk iphonesimulator \
	-target GVAnimatedPaggingTests \
	-configuration Debug \
	clean build \
	ONLY_ACTIVE_ARCH=NO \
	TEST_AFTER_BUILD=YES \
	GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES \
	GCC_GENERATE_TEST_COVERAGE_FILES=YES 