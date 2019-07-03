# keys
A Swift command line tool for managing application keys.

Keys enables you to store secrets in developer's keychains instead of committing them to source control.

## Requirements

Xcode 10.2

## Installation

### Mint

```
mint install livefront/keys
```

### Swift Package Manager

#### From the command line

```
git clone https://github.com/livefront/keys.git
cd keys
swift run keys
```

#### As a dependency

In your Package.swift:
```
.package(url: "https://github.com/livefront/keys.git", from: "0.1.0"),
```

## Usage

Add a `keys.yml` file to your project folder with a list of the keys you want to manage:

```yaml
name: "MyProject"
keys:
  - APISecret
  - SuperSecret1
```

### Setup

Run `setup`:
```
keys setup
```

The first time, it will ask you to provide values for each key.
```
❌ Keys has detected a missing keychain value.
🔑 What is the key for APISecret
> 
❌ Keys has detected a missing keychain value.
🔑 What is the key for SuperSecret1
> 
✅ All keys found. Ready to generate.

```
These values will be stored in your macOS keychain.

Options:
  - -s, --spec: An optional path to a `.yml` key spec. Defaults to `keys.yml`

### Generate

Once your keys are setup, running `generate`:
```
keys generate
🏭 Generating MyProjectKeys.swift...
```

will output a Swift file containing those secrets which you can reference in your app.

```swift
import Foundation

class MyProjectKeys {
    
    static let APISecret = "shhh"
    
    static let SuperSecret1 = "noneofyourbeeswax"
    
}
```

Options: 
   - -o, --output: The output file. Defaults to [KeySpecName]Keys.swift
   - -s, --spec: An optional path to a `.yml` key spec. Defaults to `keys.yml`.
   
### Integration

Once the file is generated, go ahead and add it to your project in Xcode, but also make sure to add it to your `.gitignore`:

```
# Ignore generated keys
MyProjectKeys.swift
```

If you want to ensure that the file is kept up to date, add a build phase to your app's target:

1. Select your app's target from the Xcode project file.
2. On the Build Phases tab, press the `+` button.
3. Select `New Run Script Phase`.
4. Drag the newly created `Run Script` entry so it is above `Compile Sources`.
5. Enter `keys generate` in the script editor. (Or if using Mint, `mint run livefront/keys keys generate`.)

## Continuous integration

When running on an environment where you don't have access to the Keychain, such as a CI server, you can also define environment variables which will be used instead to generate the Swift class. The names of the variables will be the SCREAMING_SNAKE_CASE version of the keys you have specified in `keys.yml`, prefixed with `KEYS`.

| keys.yml     | Environment variable |
| ------------ | -------------------- | 
| APISecret    | KEYS_API_SECRET      |
| SuperSecret1 | KEYS_SUPER_SECRET1   |

## Attributions

Inspired by:
  - [CocoaPods-Keys](https://github.com/orta/cocoapods-keys)
  - [Xcodegen](https://github.com/yonaskolb/XcodeGen)
