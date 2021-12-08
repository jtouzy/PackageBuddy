![packagebuddy-02](https://user-images.githubusercontent.com/5709133/145047678-ffd043ac-5441-47cf-880d-ac4d70d9ff7c.png)

# PackageBuddy: your best SPM buddy

PackageBuddy is a command-line utility providing tools to help organize, modularize, and control Swift projects that use [Swift Package Manager](https://www.swift.org/package-manager/) modularization. It fills the lack of Xcode-integrated features.

[![Latest version](https://img.shields.io/badge/Latest%20version-0.1.0-blue)](https://github.com/jtouzy/PackageBuddy)

## Summary

- [Motivations](#motivations)
- [Getting Started](#getting-started)
- [Available tools](#available-tools)
- [Feedbacks](#feedbacks)

## Motivations

Over the last few years, [Swift Package Manager](https://www.swift.org/package-manager/) has taken more and more space in Swift projects development. It has become mature  enough to be integrated in Xcode 11.

It's clearly a powerful tool to manage your external dependencies, but also to internally modularize your code. When your project starts to grow, it's a best practice to modularize your code to organize it: and splitting it into SPM modules can be a great solution.

But at this stage, some features are missing from the Xcode integration:
* If you have multiple local SPM modules, you have to manually manage the paths to the other modules: it can lead to path errors, and becomes a living hell when you have to move an SPM module in your workspace
* Xcode can easily build on your machine, and fail on your CI: because of its cache system for SPM, your Package.swift can forget some imported dependencies in your module, and your project will still build

That's why PackageBuddy has been created. It's here to provide this kind of tools, on top of [Swift Package Manager](https://www.swift.org/package-manager/) APIs.

## Getting Started

At this stage of development, PackageBuddy is not available with package management tools like `brew` (yes, it's a paradox). We're currently working on making it available more easily.

For now, to use it, clone the public project or download it, then create an alias to the distributed binary.
```bash
# in .bash_profile
alias pkgbuddy="<your_path_to_github_clone_executable>/PackageBuddy"
```

## Available tools

All examples in the tools documentation are based on the [ExampleApp](ExampleApp). This is a minimalist SwiftUI app with some SPM modules, just to show a few examples for each available command. This example app will be more complete later.

### 🔧 Checking imports consistency

Checks all your `import` statements listed in your source code and checks if your SPM module list them as they should do.

It also checks unused dependencies (listed in your `Package.swift`, but not imported in your source code).

```bash
pkgbuddy check-imports -p <project_path>
```

In the ExampleApp, all packages are fine:

<p align="center">
  <img width="800"
       alt="Screenshot 2021-12-05 at 10 54 29"
       src="https://user-images.githubusercontent.com/5709133/144742057-4c7dae2b-d95e-4a5a-9c4f-762ebcd5a7c5.png">
</p>

But if we add a random dependency to our ModuleB's `Package.swift` and don't use it in the code, we get different result:

<p align="center">
  <img width="800"
       alt="Screenshot 2021-12-05 at 11 11 42"
       src="https://user-images.githubusercontent.com/5709133/144742315-99aeba00-bb64-4319-ba59-09ea717f0f9e.png">
</p>

### 🔧 Show dependency tree

Displays the dependency tree of your project's module or a custom module.
```bash
pkgbuddy show-dependency-tree -p <project_path> -m <optional:module_name>
```

<p align="center">
  <img width="800"
       alt="Screenshot 2021-12-05 at 10 56 43"
       src="https://user-images.githubusercontent.com/5709133/144742076-de1297d4-8bfa-4b44-aef4-36316e4a362c.png">
</p>

## Feedbacks

Feedbacks & community participation is appreciated.

Feel free to open an issue or a pull request to improve PackageBuddy.
