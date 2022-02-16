# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 - 2022-02-15
### Added

- ```WrapperService:GetByIndex(Index: number) -> WrappedInstance<Instance>```
- ```WrappedInstance.Changed :: Signal<propertyKey: any, lastValue: any, newValue: any>``` Fires when a property has changed from __newindex.
- ```WrappedInstance.Called :: Signal<methodKey: any, args: ...any?>``` Fires when a function/method has been called from __index
- Better Luau types

### Changed

- ```WrappedInstance:Cleanup``` Renamed to ```WrappedInstance:Clean```
- ```WrapperService:new``` Renamed to ```WrapperService:Create``
- ```WrapperService:GetWrappedInstance``` Renamed to ```WrapperService:GetByInstance```
- All non metatable functions now use `:` instead of `.`
- [Signal](src/Signal.lua) module now uses luau typed GoodSignal instead of SignalService

### Removed

- ```WrappedInstance:WaitForProperty```

## 0.3.6 - 2022-01-05
### Added

- [License](LICENSE.md) and [README](README.md) to the wally package

## 0.3.5 - 2022-01-04
### Added

- WrappedInstance and WrapperService types to [init.lua](src/init.lua)

### Removed

- [intellisense module](src/intellisense.lua)

## 0.3.4 - 2021-12-30
### Changed

- Added [SignalService](https://wally.run/package/zxibs/signalservice) to the dependencies list in [wally.toml](https://github.com/zxibs/WrapperService/blob/main/src/wally.toml)

## 0.3.3 - 2021-12-29
### Removed

- [switch module](src/switch.lua)

## 0.3.2 - 2021-12-24
### Added

- [Moonwave documentation](https://zxibs.github.io/WrapperService/)

### Changed

- Updated [SignalService](https://wally.run/package/zxibs/signalservice) to v0.4.0
- Typechecking in [Add](src/Add.lua) function to be better

### Removed

- EmmyLua annotations in the [switch module](src/switch.lua)

## 0.3.1 - 2021-12-22
### Added

- Typechecking with [t module](https://github.com/osyrisrblx/t).

### Changed

- Updated [SignalService](https://wally.run/package/zxibs/signalservice) to v0.3.1

## 0.2.2 - 2021-12-22
### Changed

- Updated [SignalService](https://wally.run/package/zxibs/signalservice) to v0.2.1

## 0.2.1 - 2021-12-22
### Fixed

- Events not working

## 0.2.0 - 2021-12-22
### Added

- [Intellisense module](src/intellisense.lua)

### Removed

- EmmyLua annotations and added it to the [intellisense module](src/intellisense.lua)

## 0.1.0 - 2021-12-21

Initial development release
