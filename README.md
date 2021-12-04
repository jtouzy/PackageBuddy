<img width="150"
     alt="Capture d’écran 2021-12-03 à 17 26 30"
     src="https://user-images.githubusercontent.com/5709133/144723803-97d8bfc1-7a5f-47ab-9085-5862e3be437b.png">

# PackageBuddy: your best SPM buddy

PackageBuddy is a command-line utility providing tools to help organize, modularize, and control Swift projects that use [Swift Package Manager](https://www.swift.org/package-manager/) modularization. It improve the lack of Xcode-integrated features.

[![Latest version](https://img.shields.io/badge/Latest%20version-0.1.0-blue)](https://github.com/jtouzy/PackageBuddy)

## Summary

- [Motivations](#motivations)
- [Getting Started](#getting-started)
- [Available tools](#available-tools)
- [Feedbacks](#feedbacks)

## Motivations

The last few years, [Swift Package Manager](https://www.swift.org/package-manager/) takes more and more space in Swift projects development. It has become mature  enough to be integrated in Xcode 11.

It's clearly a powerful tool to manage your external dependencies, but also to internally modularize your code. When your project starts to grow, it's a best practice to modularize your code to organize it : and split it into SPM modules can be a great solution.

But at this stage, some features are
 missing from the Xcode integration :
* If you have multiple local SPM modules, you have to manually manage the paths to the other modules : it can lead to path errors, and becomes hell when you have to move an SPM module in your workspace
* Xcode can easily build on your machine, and fail on your CI: because of it's cache system for SPM, your Package.swift can forget some imported dependencies in your module, and your project will still build

That's why PackageBuddy has been created. It's here to provide those kind of tools, on top of [Swift Package Manager](https://www.swift.org/package-manager/) APIs.

## Getting Started

At this stage of development, PackageBuddy is not available with package management tools like `brew` (yes, it's a paradox). We're currently working on making it available more easily.

For now, to use it, clone the public project or download it, then create an alias to the distributed binary.
```bash
# in .bash_profile
alias pkgbuddy="/Users/jeremytouzy/Clones/PackageBuddy/Builds/PackageBuddy"
```

## Available tools

### 🔧 Checking imports consistency

Check all your `import` statements listed in your source code and checks if your SPM module list them as they should do.

It also check the opposite case, if you list too much dependencies in your Package.swift and you don't use it in your source code.

```bash
pkgbuddy check-imports -p <project_path>
```

<p align="center">
  <img width="800"
       alt="Screenshot 2021-12-04 at 21 37 17"
       src="https://user-images.githubusercontent.com/5709133/144723905-65865976-2de8-4752-b0cf-f8b74953ca0c.png">
</p>

### 🔧 Show dependency tree

Display the dependency tree of your project's module or a custom module.
```bash
pkgbuddy show-dependency-tree -p <project_path> -m <optional:module_name>
```

<p align="center">
  <img width="800"
       alt="Screenshot 2021-12-04 at 21 37 17"
       src="https://user-images.githubusercontent.com/5709133/144723905-65865976-2de8-4752-b0cf-f8b74953ca0c.png">
</p>

## Feedbacks

Feedbacks & community participation is appreciated.

Feel free to open an issue or a pull request to improve PackageBuddy.
