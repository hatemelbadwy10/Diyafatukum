  # AGENTS.md

  ## Purpose
  These are mandatory project rules. Read and follow them before starting any task, feature, refactor, or fix.

  ## Required workflow
  - Before making any change, inspect the existing implementation and reuse current project patterns.
  - Do not introduce alternative patterns when the project already has a reusable solution.
  - Follow the existing architecture, theme, localization, widgets, and pagination system.
  - Make minimal, production-safe changes only.

  ## Mandatory project rules

  ### 1) Widget extensions are required
  - Must use the widget extensions from:
    - `lib/core/config/extensions/widget_extensions.dart`
  - These extensions are mandatory and should be used on widgets wherever applicable.
  - Do not ignore them.
  - Do not replace them with custom spacing/alignment wrappers if the extension already covers the need.

  ### 2) Theme usage
  - Theme file:
    - `lib/core/config/theme/light_theme.dart`
  - The project uses **shades in colors**.
  - Always use the existing theme system and its color shades.
  - Do not hardcode colors unless explicitly requested.
  - Do not introduce new color usage patterns that bypass the theme.

  ### 3) Localization is mandatory
  - Use `LocaleKeys` for any user-facing title, label, text, button text, hint, message, or heading.
  - Any newly added text must be added in:
    - Arabic (`ar`)
    - English (`en`)
    - `LocaleKeys`
  - Do not hardcode UI strings.
  - If a title or label is added, make sure localization files are updated accordingly.

  ### 4) Reusable widgets must be reused
  - The project already contains reusable widgets.
  - Before creating a new widget or using a package widget directly, check existing reusable widgets first.
  - This includes widgets such as:
    - time picker
    - date picker
    - and other shared reusable widgets
  - Reuse existing components instead of rebuilding the same behavior.

  ### 5) Pagination widgets are mandatory for lists
  - For any paginated list/grid implementation, use the existing infinite scroll pagination widgets.
  - Do not create a new list/grid pagination solution.
  - Must use these files where applicable:
    - `lib/core/widgets/infinite_scroll_pagination/paginated_list_view.dart`
    - `lib/core/widgets/infinite_scroll_pagination/paginated_sliver_list_view.dart`
  - Also use the existing paginated grid/list variants already available in the project.
  - Any screen showing paginated data must use the project’s existing paginated components.

  ### 6) Lists must follow project components
  - Any list-based UI must use the project’s existing reusable list/grid/pagination widgets when applicable.
  - Do not build raw `ListView`, `GridView`, or custom pagination flows if the project already has a reusable equivalent.
  - Prefer the existing paginated:
    - list view
    - sliver list view
    - grid view
    - paginated grid view

  ## Implementation rules
  - Reuse existing utilities, widgets, extensions, and theme setup before adding anything new.
  - Do not create duplicate reusable components.
  - Do not bypass localization.
  - Do not bypass theme shades.
  - Do not bypass widget extensions.
  - Do not bypass the project pagination system.

  ## Before finishing any task
  - Confirm all new user-facing text uses `LocaleKeys`.
  - Confirm Arabic and English translations were added.
  - Confirm theme colors come from `light_theme.dart` and existing shades.
  - Confirm widget extensions were used where applicable.
  - Confirm list/grid screens use the existing paginated reusable widgets.
  - Confirm no unnecessary custom widget/pagination solution was introduced.

  ## Response style
  - Keep changes minimal and aligned with the current codebase.
  - Mention any rule that affected the implementation.
  - If a requested change conflicts with these rules, follow the project rules unless explicitly instructed otherwise.
  ### 7) Text styling must use context extensions

  - Do not use static TextStyle or default Flutter text styles.
  - Do not write Text without specifying style from context.
  - Always use text styles from context extension:
    - context.displayLarge
    - context.displayMedium
    - context.displaySmall
    - context.headlineLarge
    - context.headlineMedium
    - context.headlineSmall
    - context.titleLarge
    - context.titleMedium
    - context.titleSmall
    - context.bodyLarge
    - context.bodyMedium
    - context.bodySmall
    - context.labelLarge
    - context.labelMedium
    - context.labelSmall

  - Example (correct):
    Text(
      LocaleKeys.home_title.tr(),
      style: context.displayLarge,
    )

  - Example (wrong):
    Text("Home")

  - Example (wrong):
    Text(
      "Home",
      style: TextStyle(fontSize: 20),
    )

  - Any text in UI must follow the project text theme through context.
  ### 8) Any new feature must follow full project structure

  - Any new feature must be implemented using the full existing project structure, not only the UI layer.
  - This rule applies to all new features, whether the task is:
    - UI only
    - API integration
    - state management
    - partial feature update
    - or full feature implementation

  - Do not create a screen or widget alone without its expected feature layers.

  - Every new feature must include, at minimum:
    - datasource
    - repository
    - cubit
    - state
    - model(s)
    - screen/view
    - feature widgets when needed

  - Before implementing any new feature:
    - inspect similar existing features in the project
    - reuse the same architecture and file organization
    - follow the same naming style and dependency injection pattern

  ### 9) If Postman collection or API contract is missing

  - If there is no Postman collection, API documentation, or final backend contract yet, the feature must still be built using the same full structure.
  - Do not delay creating datasource, repository, cubit, state, and model(s) just because the backend is not finalized.

  - In this case, you must:
    - infer the required models from the UI and expected feature behavior
    - infer request and response fields from the screen flow and business need
    - create temporary endpoint names following the existing remote urls naming style
    - keep naming clear, predictable, and easy to replace later
    - prepare the feature so that real API integration can be plugged in with minimal changes

  - Temporary API assumptions must follow the project conventions:
    - use the existing ApiClient / Dio setup
    - use the existing datasource pattern
    - use the existing repository pattern
    - use the existing cubit/state pattern
    - use dependency injection exactly like the current project
    - do not create ad hoc or shortcut implementations

  - Placeholder or inferred API setup is allowed only as a temporary contract until the real backend contract is provided.
  - Once the actual API contract is available, only the contract-specific details should need updating, not the feature structure.

  ### 10) No presentation-only feature implementation

  - Do not implement any new feature in presentation only.
  - Even if the requested task appears to be only visual, the feature must still be prepared as a real feature using the project architecture.
  - Static UI-only implementation is not allowed unless explicitly requested as a temporary prototype.
  ### 11) New features must follow the project feature structure exactly

  - Any new feature must follow the same structure already used in the project.
  - Do not invent a new architecture, shortcut flow, or simplified implementation.

  - The expected feature structure is:
    - data/datasource
    - data/model
    - data/repository
    - presentation/controller/cubit
    - presentation/controller/state
    - presentation/view/screens
    - presentation/view/widgets when needed

  - Every new feature must be implemented in this structure even if the request is:
    - UI only
    - partial feature
    - temporary feature
    - pending backend integration

  - Do not create only a screen or only widgets without the rest of the feature layers.

  ### 12) Datasource / Repository / Model / Cubit are mandatory

  - Every new feature must include:
    - datasource
    - repository
    - model(s)
    - cubit
    - state
    - screen/view

  - The implementation must follow the same existing project style:
    - datasource uses `ApiClient`
    - datasource returns `Response`
    - repository maps response using the existing `toResult(...)` pattern
    - model uses `Equatable`
    - cubit uses the existing `CubitStatus`
    - dependency injection uses `@Injectable()` / `@LazySingleton(...)`
    - feature wiring must be compatible with the existing service locator setup

  - Do not skip any of these layers for a new feature unless explicitly instructed.

  ### 13) If Postman collection or backend contract is missing

  - If Postman collection, Swagger, or backend contract is not available yet, the feature must still be implemented using the same full structure.
  - In this case, infer the missing contract from:
    - the UI
    - the expected user flow
    - similar existing features in the project

  - When backend details are missing, you must still create:
    - datasource
    - repository
    - model(s)
    - cubit
    - state
    - screen/view

  - In this temporary contract case:
    - create placeholder endpoint names that match the existing `RemoteUrls` naming style
    - infer request and response fields from the feature behavior
    - keep naming clear and replaceable
    - keep parsing and architecture ready for easy backend replacement later

  - Missing backend details are not a reason to implement presentation only.

  ### 14) Similar feature inspection is required before implementation

  - Before implementing any new feature, inspect an existing similar feature in the repository and mirror its structure.
  - Reuse the nearest existing pattern for:
    - datasource
    - repository
    - model
    - cubit/state
    - screen/view
    - widgets
    - dependency injection

  - Do not introduce alternative naming, folder structure, or state management if the project already has an established pattern.

  ### 15) Dependency injection generation is part of feature completion

  - If the added feature requires injectable registration or generated files, run the required generator command after implementation.

  - Use:
    - `dart run build_runner build`

  - A feature is not considered complete if its dependency injection setup requires generation and that step was skipped.
  ### 16) Use API collection after UI completion

- When feature UI is finished and the endpoint/API contract is provided, use the provided Postman/API collection to complete the integration.

- Do not reread or reprocess all project rules again.
- Only use the collection to identify:
  - endpoint path
  - request method
  - request body/query params
  - response model fields
  - required headers if any

- Then update the existing feature layers only:
  - datasource
  - repository
  - model(s)
  - cubit/state if needed

- Do not change completed UI unless the API contract requires it.
- Keep the implementation aligned with the existing datasource/repository/toResult/ApiClient pattern.
- Replace any temporary endpoint/model assumptions with the real API contract from the collection.