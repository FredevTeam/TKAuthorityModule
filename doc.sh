#!/bin/sh 

jazzy \
  --clean \
  --author 抓猫的鱼 \
  --author_url https://realm.io \
  --github_url https://github.com/realm/realm-cocoa \
  --github-file-prefix https://github.com/realm/realm-cocoa/tree/v0.96.2 \
  --module-version 0.1.2 \
 --xcodebuild-arguments -workspace,TKAuthorityModule.xworkspace,-scheme,TKAuthorityModule,-configuration,Debug \
  --module TKAuthorityModule \
  --root-url https://realm.io/docs/swift/0.96.2/api/ \
  --output docs/swift_output \
  --swift-version 4.0 \
  --sdk iphone \
  --theme docs/themes