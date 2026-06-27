# MedConnect Implementation Plan

This document outlines the phased implementation plan for the MedConnect application.

## Journal

**Phase 1: Project Setup**

*   Successfully created the Flutter project and removed the boilerplate code.
*   Updated the `pubspec.yaml` with the correct version number.
*   Created the `README.md` and `CHANGELOG.md` files.
*   The initial project setup was committed to the `feat/mediconnect-initial-setup` branch.
*   No surprises or deviations from the plan.

**Phase 2: Core & Common Setup**

*   Created the directory structure for `core` and `common` features.
*   Added `google_fonts`, `go_router`, and `flutter_secure_storage` packages.
*   Set up the application theme with light and dark modes and the "Inter" font.
*   Configured basic routing.
*   A small mistake was made by creating files in non-existent directories, but it was corrected by creating the directories and rewriting the files.

## Implementation Plan

### Phase 1: Project Setup

- [x] Create a new Flutter project named `mediconnect` in the current directory.
- [x] Remove the boilerplate code in `lib/main.dart` and the `test` directory.
- [x] Update the `description` in `pubspec.yaml` to "A new Flutter project." and set the version to `0.1.0`.
- [x] Create a placeholder `README.md` file with a short description of the project.
- [x] Create a `CHANGELOG.md` file with an initial version of `0.1.0`.
- [x] Commit the initial empty version of the package to the `feat/mediconnect-initial-setup` branch.

### Phase 2: Core & Common Setup

- [x] Create the directory structure for `core` and `common` as outlined in the `DESIGN.md`.
- [x] Add the `google_fonts` package to use the "Inter" font.
- [x] Set up the theme for the application, including light and dark modes and the "Inter" font.
- [x] Add the `go_router` package for navigation.
- [x] Set up the basic routing for the application.
- [x] Add the `flutter_secure_storage` package.

### Phase 3: Authentication Feature

- [x] Implement the authentication feature under `lib/common/auth`.
- [x] Create the data, domain, and presentation layers for authentication.
- [x] Implement the UI for the sign-up and login screens.
- [ ] Implement the logic for email/phone number verification.

### Phase 3.5: Onboarding Flow

- [x] Implement the onboarding pages and flow.

### Phase 4: Patient App - Home & Medication

- [ ] Create the directory structure for the `patient_app` feature.
- [ ] Implement the Home Dashboard for the patient app.
- [ ] Implement the medication search and browse functionality.
- [ ] Implement the medication details screen.

### Phase 5: Patient App - Pharmacy & Medical History

- [ ] Implement the nearby pharmacies feature.
- [ ] Implement the pharmacy details screen.
- [ ] Implement the medical history management feature.

### Phase 6: Pharmacist App - Core Features

- [ ] Create the directory structure for the `pharmacist_app` feature.
- [ ] Implement the UI and logic for managing pharmacy and personal information.
- [ ] Implement the inventory management feature.

### Phase 7: Finalization

- [ ] Create a comprehensive `README.md` file for the package.
- [ ] Create a `GEMINI.md` file in the project directory that describes the app, its purpose, and implementation details of the application and the layout of the files.
- [ ] Ask you to inspect the app and the code and say if you are satisfied with it, or if any modifications are needed.
