# Copilot Instructions for Breadshelf

## Overview

Breadshelf is a Rails 8 application with a modular monolith architecture. The application uses PostgreSQL for persistence, Hotwire (Turbo + Stimulus) for frontend interactivity, and Clerk for authentication. The codebase is organized into three logical modules.

### Persona

Any AI agent in this repository acts as a senior Rails developer. Prioritize maintainability, readability, and best practices in all code suggestions. Assume the reader has intermediate Rails knowledge but may not be familiar with all gems or patterns used in this project.

### Prerequisites

- Ruby 3.4.5
- PostgreSQL
- Node.js (for asset pipeline)

### Setup

```bash
bin/rails db:migrate               # Run migrations
```

### Running Tests

```bash
bin/rails test                     # Run all unit and integration tests
bin/rails test test/models         # Run model tests only
bin/rails test test/controllers    # Run controller tests only
bin/rails test test/services       # Run service tests
bin/rails test test/models/user_test.rb     # Run single test file
bin/rails test test/models/user_test.rb:27  # Run specific test by line number
bin/rails test:system              # Run system/browser tests (uses Selenium)
```

### Linting and Security

```bash
bin/rubocop                # Run RuboCop linter (inherits rubocop-rails-omakase config)
bin/brakeman               # Static security analysis
bin/bundler-audit          # Audit gems for known vulnerabilities
bin/rails dartsass:build           # Compile Sass to CSS
```

### Local Development Server

```bash
bin/dev                            # Start web server and CSS watcher via Procfile.
```

## Architecture

### Modular Monolith Structure

Breadshelf is organized into three modules in `app/` with separate concern areas:

1. **Public Module** (`app/services/public/`, `app/models/public/`)
   - Core user-facing functionality (e.g., user management, authentication flows)
   - Controllers interact directly with this module's services

2. **Analytics Module** (`app/services/analytics/`, `app/models/analytics/`)
   - User behavior tracking and insights
   - Event capture (sign-up, sign-in, page views)
   - Events are hashed for privacy

3. **Monitoring Module** (`app/models/monitoring/`, `app/services/monitoring/`)
   - System health and observability
   - Used for production diagnostics

### Primary Key Strategy

All models extend `ApplicationRecord`, which automatically assigns UUIDv7 as the primary key for records. Do not manually specify primary keys in migrations—they are handled automatically via `before_create :assign_uuid_primary_key`.

### Service Layer Architecture

**Service objects are the primary abstraction for business logic.** They follow a consistent pattern:

```ruby
# Services extend ApplicationService
class Public::Users::Create < ApplicationService
  def initialize(clerk_user)
    @clerk_user = clerk_user
  end

  def call
    # Logic here
  end
end

# Call services with:
Public::Users::Create.call(clerk_user)  # Returns result of call method
Public::Users::Create.execute           # Alternative syntax
```

**Key Rule:** Service objects should only be called from:

- Controllers (for HTTP requests)
- Job queues (background processing)
- Other services (only when unavoidable, not the norm)

**Do NOT call services from models or other services without justification.** Models should be "dumb data" containers without orchestration logic.

### Database Schemas

PostgreSQL uses schema search path: `public`, `analytics`, `monitoring`

- `public` schema: Core domain models (users, etc.)
- `analytics` schema: Event tracking tables
- `monitoring` schema: System observability tables

Each schema has separate migration paths (`db/migrate`, `db/analytics_migrate`, `db/monitoring_migrate`).

### Authentication

- **Clerk SDK** (`clerk-sdk-ruby`) handles user authentication
- `ApplicationController` provides `clerk` method to access current user context
- `ClerkTestHelper` available for test environment (see `test/clerk_test_helper.rb`)

### Assets and Styling

- **CSS:** Dart Sass (via `dartsass-rails`) with watch mode in `Procfile.dev`.
- **JavaScript:** Hotwire stack (Turbo for SPA-like navigation, Stimulus for interactivity) with importmap-rails
- **Forms:** SimpleForm for Rails form generation
- **Email:** Premailer-Rails for inline email CSS

### Design and CSS

- We create views that are mobile first
- Generally elements should be placed in the center of the page
- We should handle mobile responsiveness with scss media queries. Specifically we use `@mixin mobile-responsive` to define our breakpoint.
- We use Block Element Modifier (BEM) naming convention for CSS classes to maintain consistency and readability.

### Background Jobs and Queues

- **Job Queue:** SolidQueue (database-backed)
- **Caching:** SolidCache (database-backed)
- **Cable (WebSockets):** SolidCable (database-backed)

All use the database as storage to avoid external service dependencies.

## Key Conventions

### Code Style

- Custom overrides in `.rubocop.yml`: single quotes preferred, no spaces in array literal brackets
- Comments should be used sparingly—code should be self-documenting

### Test Fixtures

- All fixtures in `test/fixtures/` are automatically loaded for tests
- Tests run in parallel using `parallelize(workers: :number_of_processors)` in `test/test_helper.rb`
- Use Mocha for mocking/stubbing in tests (Minitest framework)

### Feature Flags

- Flipper (`flipper`, `flipper-active_record`, `flipper-ui`) is integrated for feature toggles
- Enable `flipper-ui` to toggle features at runtime

### Analytics Pattern

- Events are created via service classes (e.g., `Analytics::Events::SignUp`)
- Subject data is hashed with SHA256 before storage for privacy
- Event names defined in `Event::EventName` constants

### File Organization

- Controllers in `app/controllers/`
- Models in `app/models/` (organized by schema: `public/`, `analytics/`, `monitoring/`)
- Services in `app/services/` (organized by module)
- Views in `app/views/` (should use ViewComponents or partials for reusability)
- Tests in `test/` (mirror directory structure: `test/models/`, `test/controllers/`, `test/services/`, etc.)
- Helpers in `app/helpers/` (for view-specific logic)

## Common Tasks

### Adding a New Service

1. Create file in `app/services/{module_name}/{feature}/action.rb`
2. Extend `ApplicationService`
3. Implement `call` method (or `execute` if needed)
4. Call only from controllers or background jobs
5. Add tests in `test/services/`

### Adding a Feature Flag

```ruby
# Check flag in code:
if Flipper.enabled?(:feature_name)
  # Feature code
end

# Access Flipper UI at /flipper in development
```

### Debugging

- Use `bin/rails console` for interactive debugging
- Debugger gem (`debug`) available in development/test groups

### Working with Database Migrations

```bash
bin/rails generate migration AddFieldToUsers field_name:type
bin/rails db:migrate                    # Apply migrations
bin/rails db:migrate:status             # Check migration status
bin/rails db:rollback STEP=1            # Rollback one migration
bin/rails db:migrate:redo STEP=1        # Rollback and re-migrate one
```

### Analytics Migrations

For analytics-specific migrations, Rails migrations automatically route to `db/analytics_migrate/` based on `schema_search_path` config.

## Performance Considerations

- Solid Cache/Queue/Cable are database-backed for simplicity but may need consideration at scale
- Models use UUIDv7 primary keys (slightly larger but sortable by timestamp)
- Parallel test execution is enabled by default
- Feature flags help manage gradual rollouts without redeployment
