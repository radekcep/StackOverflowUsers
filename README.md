# StackOverflowUsers

This repo contains a small showcase application in MVVM-C with domain logic organized according to clean architecture.  

## Repo Overview

Each new feature should follow the structure of:
```
FeatureXY
 - Data
  - XService.swift
  - YService.swift
  - ...
 - Domain
  - XUseCase.swift
  - YUseCase.swift
  - ...
 - View
  - XYViewController.swift
  - XYViewModel.swift
  - ...
 XYCoordinator.swift
```
There are 2 features in the repo (`UsersFeature`, `ErrorFeature`) and some common UI code (`CommonUI`). Most use cases, and view model logic are tested. 

But since this was a limited time assigment, some corners had to be cut. There's no lint setup. And no snapshot tests. No dependency injection.

There're also no protocols for common components like Coordinators and ViewModels. 

## Screenshot

<img width="402" height="874" alt="simulator_screenshot_3C745E28-F677-49DB-977D-E892C263041D" src="https://github.com/user-attachments/assets/99b8d90c-42a4-4bb6-98e2-de143766e87a" />
