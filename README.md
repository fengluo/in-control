# in-control
A tool for controlling macOS

## Build

Run `make build`

You can change the `Info.plist` of `in-controll.app` for hiding the dock icon with the code below.
```
<key>LSUIElement</key>
<string>1</string>
```

## Install

Put `in-controll.app` into `Application`