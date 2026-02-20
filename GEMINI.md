# Mediconnect — Flutter Project Instruction Set

This file defines strict architectural and coding rules.
All generated and modified code must comply with this document.

---

# 🔧 GENERAL RULES

- Follow existing architecture.
- Do not introduce new architectural patterns without approval.
- Do not mix navigation systems.
- Keep code modular and reusable.

---

# 🚀 NAVIGATION (GoRouter Only)

We use **GoRouter exclusively**.

Never use:
- Navigator.push
- Navigator.pop
- Navigator.pushNamed
- MaterialPageRoute

Navigation helpers live in:

lib/core/router/k_navigate.dart

Routes must be registered in:

lib/core/router/routes_names.dart  
lib/core/router/app_router.dart

Navigation must use:

context.go(route);     // replace stack
context.push(route);   // push onto stack
context.pop();         // go back

Use `push()` for normal forward navigation.
Use `go()` only for root-level transitions (e.g. auth → main app).

---

# 🎨 THEMING & TEXT STYLES

The project enforces centralized styling.

Theme file:
lib/core/theme/app_theme.dart

Text styles file:
lib/core/constants/text_styles.dart

Rules:
- Never hardcode colors.
- Never hardcode font sizes.
- Never define inline TextStyle unless absolutely necessary.

Always use:
AppTheme.someColor  
AppTextStyles.someStyle  

---

# 🖼 ICONS & ASSETS

Asset paths must NEVER be hardcoded.

All asset references must use:

lib/core/constants/assets.dart

Specifically:

AppIcon.someIconName

SVG icons must be rendered using:

SvgPicture.asset(
  AppIcon.someIconName,
)

Never use:
- Direct string paths
- Image.asset for SVG files
- Icons.* unless explicitly required by design

All icons in this project are SVG-based.

---

# 🧱 SCAFFOLD STRUCTURE

Do NOT use raw Scaffold directly.

Instead, always use:

lib/common/widgets/app_scaffold.dart

AppScaffold must wrap all main screens unless there is a very specific reason not to.

Example:

return AppScaffold(
  child: YourWidget(),
);

This ensures consistent:
- App bars
- Background styling
- Padding behavior
- Global layout consistency

---

# 🧠 STATE MANAGEMENT

We use Riverpod exclusively.

- Use riverpod_annotation
- Use build_runner
- Avoid setState for global state
- Do not introduce other state management solutions

Use:
@riverpod
ref.watch()
ref.read()
ref.select()

---

# 📦 MODELS

Before creating a new model:

1. Search for an existing similar model.
2. If it exists:
   - Refactor it.
   - Add required properties.
   - Preserve serialization compatibility.

Models must:
- Support JSON serialization
- Be compatible with build_runner
- Follow project naming conventions

---

# 🛠 CODE GENERATION

When annotations are added or modified:

Run:

flutter pub run build_runner build --delete-conflicting-outputs

Generated files must not contain errors before finalizing code.

---

# 📏 LINTING & CLEAN CODE

Follow flutter_lints strictly.

- No unused imports
- No unnecessary null checks
- No suppressed warnings without explanation

---

# ⚡ PERFORMANCE GUIDELINES

- Use const constructors where possible.
- Avoid heavy computations in build().
- Use ref.select() to reduce rebuilds.
- Extract reusable widgets when repeated UI appears.

---

# 📁 FILE STRUCTURE

When adding new features:

- Follow existing feature folder structure.
- Add route names to routes_names.dart.
- Register routes in app_router.dart.
- Use AppScaffold.
- Use AppTheme.
- Use AppTextStyles.
- Use AppIcon for assets.

---

# 📜 FINAL RULE

All generated code must feel like it was written by a mid-to-senior Flutter engineer maintaining a scalable production application.