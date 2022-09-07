# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.2 - 2022-09-07
### Changed

- CHANGED: changed some old shit code by @lisachandra ([2b07ba5](https://github.com/zxibs/WrapperService/commit/2b07ba5bb53f20c17a0c26008c7e8c38cd109a98))
## 1.0.1 - 2022-02-16
### Fixed

- ```WrappedInstance:Clean``` not disconnecting custom signals

## 1.0.0 - 2022-02-15
### Added

- ```WrapperService:GetByIndex(Index: number) -> WrappedInstance<Instance>```
- ```WrappedInstance.Changed :: Signal<propertyKey: any, lastValue: any, newValue: any>``` Fires when a property has changed from __newindex.
- ```WrappedInstance.Called :: Signal<methodKey: any, args: ...any?>``` Fires when a function/method has been called from __index
- Better Luau types

### Changed

- ```WrappedInstance:Cleanup``` Renamed to ```WrappedInstance:Clean```
- ```WrapperService:new``` Renamed to ```WrapperService:Create```
- ```WrapperService:GetWrappedInstance``` Renamed to ```WrapperService:GetByInstance```
- All non metatable functions now use `:` instead of `.`
- Signal module now uses luau typed GoodSignal instead of SignalService

### Removed

- ```WrappedInstance:WaitForProperty```

## 0.3.6 - 2022-01-05
### Added

- License and README to the wally package

## 0.3.5 - 2022-01-04
### Added

- WrappedInstance and WrapperService types to init.lua

### Removed

- intellisense module

## 0.3.4 - 2021-12-30
### Changed

- Added SignalService to the dependencies list in wally.toml

## 0.3.3 - 2021-12-29
### Removed

- switch module

## 0.3.2 - 2021-12-24
### Added

- Moonwave documentation

### Changed

- Updated SignalService to v0.4.0
- Typechecking in Add function to be better

### Removed

- EmmyLua annotations in the switch module

## 0.3.1 - 2021-12-22
### Added

- Typechecking with t module.

### Changed

- Updated SignalService to v0.3.1

## 0.2.2 - 2021-12-22
### Changed

- Updated SignalService to v0.2.1

## 0.2.1 - 2021-12-22
### Fixed

- Events not working

## 0.2.0 - 2021-12-22
### Added

- Intellisense module

### Removed

- EmmyLua annotations and added it to the intellisense module

## 0.1.0 - 2021-12-21

Initial development release
