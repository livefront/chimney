# Chimney
A Swift command line tool for managing application keys.

Chimney enables you to store secrets in developer's keychains instead of committing them to source control.

## Requirements

Xcode 10.2

## Installation

### Mint

```
mint install livefront/chimney
```

### Swift Package Manager

#### From the command line

```
git clone https://github.com/livefront/chimney.git
cd chimney
swift run chimney
```

#### As a dependency

In your Package.swift:
```
.package(url: "https://github.com/livefront/chimney.git", from: "0.1.0"),
```

## Usage

Add a `chimney.yml` file to your project folder with a list of the keys you want to manage:

```yaml
name: "MyProject"
keys:
  - APISecret
  - SuperSecret1
```

### Setup

Run `setup`:
```
chimney setup
```
or (if installed via Mint)
```
mint run chimney setup
```

The first time, it will ask you to provide values for each key.
```
❌ Chimney has detected a missing keychain value.
🔑 What is the key for APISecret
> 
❌ Chimney has detected a missing keychain value.
🔑 What is the key for SuperSecret1
> 
✅ All keys found. Ready to generate.

```
These values will be stored in your macOS keychain.

Options:
  - -s, --spec: An optional path to a `.yml` key spec. Defaults to `chimney.yml`

### Generate

Once your keys are setup, running `generate`:
```
chimney generate
🏭 Generating MyProjectKeys.swift...
```
or (if installed via Mint)
```
mint run chimney generate
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
   - -s, --spec: An optional path to a `.yml` key spec. Defaults to `chimney.yml`.
   
### Get

As an alternative to accessing secrets at runtime via the generated file, `get` can be used to get a secret for a key. This enables build time scripts to access secrets.

```
chimney get <key>
```
or (if installed via Mint)
```
mint run chimney get <key>
```

Options:
  - -s, --spec: An optional path to a `.yml` key spec. Defaults to `chimney.yml`

### Integration

Once the file is generated, go ahead and add it to your project in Xcode, but also make sure to add it to your `.gitignore`:

```
# Ignore generated keys
MyProjectKeys.swift
```

If you want to ensure that the file is kept up to date automatically, add a Run Script build phase to your app's target:

#### Xcode

1. Select your app's target from the Xcode project file.
2. On the Build Phases tab, press the `+` button.
3. Select `New Run Script Phase`.
4. Drag the newly created `Run Script` entry so it is above `Compile Sources`.
5. Enter `chimney generate` in the script editor. (Or if using Mint, `mint run livefront/chimney chimney generate`.)

#### Xcodegen

1. In your `project.yml`, add a path to your generated class in the app's main target with the flag `optional: true`.
2. Add a script to your `preBuildScripts` section that runs `chimney generate`. (Or if using Mint, `mint run livefront/chimney chimney generate`.)

Example `project.yml`:
```yml
targets:
  MyProject:
    sources:
      - path: Sources
      - path: MyProjectKeys.swift
        optional: true
    preBuildScripts:
      - script: chimney generate
        name: Chimney
```

## Continuous integration

When running on an environment where you don't have access to the Keychain, such as a CI server, you can also define environment variables which will be used instead to generate the Swift class. The names of the variables must match the names of the keys you have specified in `chimney.yml`.

## Attributions

Inspired by:
  - [CocoaPods-Keys](https://github.com/orta/cocoapods-keys)
  - [Xcodegen](https://github.com/yonaskolb/XcodeGen)
