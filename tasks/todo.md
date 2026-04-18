# MedConnect MVP Execution Plan & Timeline

## Overview
This document outlines the detailed plan, structured tasks, and professional timeline to complete the MedConnect Minimum Viable Product (MVP). The plan is divided into logical phases, ensuring technical robustness and UI/UX excellence, optimized for a single developer's execution context.

---

**Objective:** Finalize the Pharmacist system logic, complete backend integrations (Firestore & Hive), and connect the existing UI components to the state management layer.

### Week 1: Auth Workflow, Data Binding & Inventory Systems
- [ ] **Auth System & Multi-Tenancy Integration**
  - [ ] Hook Sign-Up to Firebase Auth and generate a base `UserModel` in the `/users` root collection containing `uid`, `name`, `email`.
  - [ ] Mock `CodeVerificationPage` to push seamlessly to `/setup-finalization`.
  - [ ] Update `UserModel` with the chosen role on Setup Finalization.
  - [ ] For Pharmacists, capture details in `InformationCapturePage` and generate a `Business` document in the `/businesses` root collection.
  - [ ] Implement Multi-tenancy mapping by writing `{bid, role}` to the `/users/{uid}/memberships` subcollection.
  - [ ] Store User, Memberships, and Business instances locally using Hive for offline-first capabilities.
- [ ] **Dashboard Integration**
  - [ ] Connect `PharmacistDashboard` to real data sources (replace hardcoded "Average Rating", "Total SKUs", "Low Stock", and "Expiring" dummy stats).
  - [ ] Implement query logic to calculate and push real-time updates for Sales Activity & Recent Dispense lists.
- [ ] **Inventory Logic & Connections**
  - [ ] Audit `inventory_repository_impl.dart` & `medication_catalog_repository_impl.dart`.
  - [ ] fully integrate `InventoryProvider` so that the `InventoryPage` dynamically groups and searches active stock from the backend.
  - [ ] Connect `InventoryItemEditPage` for full CRUD capabilities.
- [ ] **Medication Catalog Workflow**
  - [ ] Finalize `AddMedicationPage` connecting local Hive databases for offline support and syncing to Firestore.

### Week 2: Dispense Workflow & User Profile
- [ ] **Dispensing & History Validation**
  - [ ] Wire `DispenseEntryPage` logic to securely process and record stock reductions.
  - [ ] Bind `DispenseHistoryPage` to `DispenseRepository` for fetching, sorting, and receipt generation.
- [ ] **Profile & Pharmacy Settings**
  - [ ] Connect account changes (Security, Personal Details, Pharmacy Info) with Firebase Authentication and the remote user profile.
  - [ ] Wire up Notification and Preferences state logic (Hive/SharedPreferences).
- [ ] **QA & Refinement:** End-to-end testing for the complete pharmacist lifecycle loop.

---

## Phase 2: Patient Application Completion (Weeks 3 & 4)
**Objective:** Finalize the UI architectures for the Patient App to match premium aesthetic guidelines, and implement all associated logic/network layers.

### Week 3: UI / UX Finalization (Patient)
- [ ] **Patient Dashboard**
  - [ ] Build out a polished, visually engaging `DashboardPage` featuring dynamic greeting, quick actions, and nearby pharmacy suggestions.
- [ ] **Search & Discovery Interface**
  - [ ] Develop `SearchPage` UI. Include advanced filter tags, interactive lists, and engaging micro-animations for querying medications or local pharmacies.
- [ ] **Activity & Core Profile**
  - [ ] Build the `ActivityPage` layout tailored to tracking ongoing and past prescription orders/requests.
  - [ ] Design the patient `ProfilePage` following existing Design System principles `(AppTheme & AppTextStyles)`.

### Week 4: Business Logic & Network Layer (Patient)
- [ ] **Model & Repository Construction**
  - [ ] Create specialized Network / Database repositories for Patient queries.
- [ ] **Provider Wiring**
  - [ ] Connect Patient `Dashboard` and `Search` directly to repositories via Riverpod.
  - [ ] Handle patient-specific edge cases (e.g., location permissions, connection statuses, empty states).
- [ ] **Order Request Pipeline**
  - [ ] Wire Patient UI so orders can successfully hit the pharmacist Dispense logic across the system. 

---

## Phase 3: Final Integration & QA (Week 5)
**Objective:** Complete system integration testing, bug fixing, and beta deployment readiness.

### Week 5: Launch Prep
- [ ] **System-Wide Optimization**
  - [ ] Identify and clean up unused widgets & imports (Run `flutter_lints`).
  - [ ] Ensure all generated code (`build_runner`) aligns optimally to reduce memory bloat.
- [ ] **Testing & Safety**
  - [ ] Review Firebase Firestore caching configurations and Security rules to ensure strict separation of access between Customer and Pharmacist nodes.
  - [ ] Full Manual run-through of user flows.
- [ ] **Deployments**
  - [ ] Prep Android (AAB) & iOS (IPA) release builds.

---
## Summary Timeline Projection

| Phase | Milestone Focus | Duration | Delivery Estimate |
|---|---|---|---|
| **Phase 1** | Pharmacist Logic & State Integrations | 2 Weeks | End of Week 2 |
| **Phase 2** | Patient UI & Logic Integration | 2 Weeks | End of Week 4 |
| **Phase 3** | Quality Assurance, Testing & Deployment | 1 Week | End of Week 5 |

*Note: Timeline assumes standard part-time to full-time commitment and follows MedConnect architectural guidelines (Clean Architecture with Riverpod & GoRouter).*
