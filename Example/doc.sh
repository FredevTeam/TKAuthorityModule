#!/bin/sh 

jazzy \
  --clean \
  --author 抓猫的鱼 \
  --author_url https://realm.io \
  --github_url https://github.com/realm/realm-cocoa \
  --github-file-prefix https://github.com/realm/realm-cocoa/tree/v0.96.2 \
  --module-version 0.1.2 \
  --build-tool-arguments -scheme,TKAuthorityModule \
  --module TKAuthorityModule \
  --root-url https://realm.io/docs/swift/0.96.2/api/ \
  --output docs/swift_output \
  --theme docs/themes