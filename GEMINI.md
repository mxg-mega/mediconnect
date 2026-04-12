# Mediconnect — Flutter Project Instruction Set

This file defines strict architectural and coding rules.
All generated and modified code must comply with this document.

---

# 🔧 GENERAL RULES

- Follow existing architecture.
- Do not introduce new architectural patterns without approval.
- Do not mix navigation systems.
- Keep code modular and reusable.

## Workflow Orchestration

### 1. Plan Node Default

- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions)
- If something goes sideways, STOP and re-plan immediately - don't keep pushing
- Use plan mode for verification steps, not just building
- Write detailed specs upfront to reduce ambiguity

### 2. Subagent Strategy

- Use subagents liberally to keep main context window clean
- Offload research, exploration, and parallel analysis to subagents
- For complex problems, throw more compute at it via subagents
- One tack per subagent for focused execution

### 3. Self-Improvement Loop

- After ANY correction from the user: update `tasks/lessons.md` with the pattern
- Write rules for yourself that prevent the same mistake
- Ruthlessly iterate on these lessons until mistake rate drops
- Review lessons at session start for relevant project

### 4. Verification Before Done

- Never mark a task complete without proving it works
- Diff behavior between main and your changes when relevant
- Ask yourself: "Would a staff engineer approve this?"
- Run tests, check logs, demonstrate correctness

### 5. Demand Elegance (Balanced)

- For non-trivial changes: pause and ask "is there a more elegant way?"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution"
- Skip this for simple, obvious fixes - don't over-engineer
- Challenge your own work before presenting it

### 6. Autonomous Bug Fizing

- When given a bug report: just fix it. Don't ask for hand-holding
- Point at logs, errors, failing tests then resolve them
- Zero context switching required from the user
- Go fix failing CI tests without being told how

## Task Management

1. **Plan First**: Write plan to `tasks/todo.md` with checkable items
2. **Verify Plan**: Check in before starting implementation
3. **Track Progress**: Mark items complete as you go
4. **Explain Changes**: High-level summary at each step
5. **Document Results**: Add review section to `tasks/todo.md`
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections

## Core Principles

- **Simplicity First**: Make every change as simple as possible. Impact minimal code.
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards.
- **Minimat Impact**: Changes should only touch what's necessary. Avoid introducing bugs.

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
