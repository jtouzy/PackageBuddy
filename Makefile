build:
	swift build -c release --disable-sandbox

install: build
	mkdir -p "$(prefix)/bin"
	cp -L -R .build/release/* "$(prefix)/bin/."

clean:
	rm -rf .build
