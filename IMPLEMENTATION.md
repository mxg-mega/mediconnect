# MedConnect Implementation Plan

This document outlines the phased implementation plan for the MedConnect application.

## Journal

This section will be updated after each phase to log actions taken, things learned, surprises, and deviations from the plan.

## Implementation Plan

### Phase 1: Project Setup

- [ ] Create a new Flutter project named `mediconnect` in the current directory.
- [ ] Remove the boilerplate code in `lib/main.dart` and the `test` directory.
- [ ] Update the `description` in `pubspec.yaml` to "A new Flutter project." and set the version to `0.1.0`.
- [ ] Create a placeholder `README.md` file with a short description of the project.
- [ ] Create a `CHANGELOG.md` file with an initial version of `0.1.0`.
- [ ] Commit the initial empty version of the package to the `feat/mediconnect-initial-setup` branch.

After completing a task, if you added any TODOs to the code or didn't fully implement anything, make sure to add new tasks so that you can come back and complete them later.

After each phase, I will:

- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the `dart_fix` tool to clean up the code.
- [ ] Run the `analyze_files` tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to make sure that the formatting is correct.
- [ ] Re-read the `IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the `IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes. I will present the change message to you for approval.
- [ ] Wait for your approval. I will not commit the changes or move on to the next phase of implementation until you approve the commit.
- [ ] After committing the change, if the app is running, I will use the `hot_reload` tool to reload it.

### Phase 2: Core & Common Setup

- [ ] Create the directory structure for `core` and `common` as outlined in the `DESIGN.md`.
- [ ] Add the `google_fonts` package to use the "Inter" font.
- [ ] Set up the theme for the application, including light and dark modes and the "Inter" font.
- [ ] Add the `go_router` package for navigation.
- [ ] Set up the basic routing for the application.
- [ ] Add the `flutter_secure_storage` package.

### Phase 3: Authentication Feature

- [ ] Implement the authentication feature under `lib/common/auth`.
- [ ] Create the data, domain, and presentation layers for authentication.
- [ ] Implement the UI for the sign-up and login screens.
- [ ] Implement the logic for email/phone number verification.

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
