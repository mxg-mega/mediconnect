# MedConnect

A comprehensive mobile application for both patients and pharmacists.

## Documentation

The detailed documentation for MedConnect is located in the `docs/` directory:

- [Architecture & Design](docs/architecture_design.md)
- [Data Schema](docs/data_schema.md)
- [Developer Guide](docs/developer_guide.md)
- [Getting Started](docs/getting_started.md)

---

## Design Tokens: Typography (Figma/Zeplin -> Flutter)

This project’s typography is sourced from the Zeplin-generated file `assets/fonts.css`.

In Flutter, we expose those tokens through the standard Material `TextTheme` in `lib/core/theme/app_theme.dart`.

### Mapping table

| Figma/Zeplin style name (fonts.css) | Font | Size | Weight | Line height | Flutter `TextTheme` key |
| --- | --- | ---: | ---: | ---: | --- |
| `Inter-32-M` | Inter | 32 | 500 | normal | `displayLarge` |
| `Inter-24-M` | Inter | 24 | 500 | normal | `titleLarge` (closest) |
| `Inter-P-24-R` | Inter | 24 | 400 | normal | `titleLarge` |
| `H1-SB` | Outfit | 22 | 600 | 1.26 | `headlineMedium` |
| `Inter-P-22-M` | Inter | 22 | 500 | normal | `titleMedium` |
| `Inter-P-22-R` | Inter | 22 | 400 | normal | `titleMedium` (closest) |
| `Inter-P-20-M` | Inter | 20 | 500 | normal | `titleMedium` (closest) |
| `Inter-P-20-R` | Inter | 20 | 400 | normal | `titleMedium` (closest) |
| `H2-SB` | Outfit | 18 | 600 | 1.26 | `headlineSmall` |
| `Inter-P-18-M` | Inter | 18 | 500 | normal | `bodyLarge` (closest) |
| `Inter-P-18-R` | Inter | 18 | 400 | normal | `bodyLarge` |
| `H3-SB` | Outfit | 16 | 600 | normal | `titleSmall` |
| `Inter-P-16-SM` | Inter | 16 | 600 | normal | `bodyMedium` (closest) |
| `Inter-P-16-M` | Inter | 16 | 500 | normal | `bodyMedium` (closest) |
| `Inter-P-16-R` | Inter | 16 | 400 | 1.38 | `bodyMedium` |
| `H4-SB` | Outfit | 14 | 600 | normal | `labelLarge` (closest) |
| `P-14-SM` | Inter | 14 | 600 | normal | `labelLarge` |
| `Inter-P-14-M` | Inter | 14 | 500 | normal | `bodySmall` (closest) |
| `Inter-P-14-R` | Inter | 14 | 400 | normal | `bodySmall` |
| `H5-SB` | Outfit | 12 | 600 | normal | `labelMedium` (closest) |
| `Inter-P-12-M` | Inter | 12 | 500 | normal | `labelMedium` |
| `Inter-P-12-R` | Inter | 12 | 400 | normal | `labelSmall` |

### How to use in code

Use your `BuildContext` to access the theme:

- `context.textTheme.displayLarge`  (≈ `Inter-32-M`)
- `context.textTheme.headlineMedium` (≈ `H1-SB`)
- `context.textTheme.bodyMedium` (≈ `Inter-P-16-R`)

Example:

```dart
Text(
  'Welcome',
  style: Theme.of(context).textTheme.headlineMedium,
)
```

### Notes

- Some Zeplin styles don’t have a perfect 1:1 match in Material’s `TextTheme`. In those cases, the table uses the **closest** semantic slot.
- If you want *exact* token naming (e.g. `AppTextStyles.h1Sb`, `AppTextStyles.interP16R`) we can add a dedicated `AppTextStyles` class that wraps these styles with the original names.