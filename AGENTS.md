# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Commands

```bash
# Development
bin/dev                                         # Start web + CSS watcher (Procfile.dev)

# Database
bin/rails db:migrate
bin/rails db:migrate:status
bin/rails db:rollback STEP=1

# Tests
bin/rails test                                  # All unit and integration tests
bin/rails test test/models/user_test.rb         # Single file
bin/rails test test/models/user_test.rb:27      # Single test by line number
bin/rails test:system                           # System/browser tests (Selenium)

# Linting and security
bin/rubocop                                     # Linting (rubocop-rails-omakase config)
bin/brakeman                                    # Static security analysis
bin/bundler-audit                               # Gem vulnerability audit
bin/rails dartsass:build                        # Compile Sass to CSS
```

## Architecture

Breadshelf is a Rails 8 modular monolith with three modules, each represented across `app/models/`, `app/controllers/`, and `app/services/`:

- **public** — core user-facing functionality (users, books, entries)
- **analytics** — user behavior tracking (events hashed with SHA256 for privacy)
- **monitoring** — system health and observability

PostgreSQL uses schema search path `public`, `analytics`, `monitoring` to isolate module data.

### Service Layer

Service objects are the **sole abstraction for business logic**. Call them from controllers or background jobs only — not from models, and not from other services without strong justification.

```ruby
# All services extend ApplicationService and implement `call`
Public::Users::Create.call(clerk_user)   # preferred
Public::Users::Create.execute            # alternative
```

### Authentication

Clerk SDK handles authentication. `ApplicationController` exposes the `clerk` helper. Every request also has an anonymous user tracked via a `_anonymous_user_id` cookie (`Public::Users::GetOrCreate`), which is replaced by a real user on sign-in.

In tests, use `ClerkTestHelper` (included in all test cases):

```ruby
clerk_sign_in           # sets up a mock authenticated user
clerk_sign_out          # default; no authenticated user
clerk_sign_in(user_attrs: { id: 'user_456' })  # custom attributes
```

### Primary Keys

`ApplicationRecord` automatically assigns UUIDv7 primary keys via `before_create`. Do not specify primary keys manually in migrations.

### Frontend

- Hotwire (Turbo + Stimulus) with importmap — no Node bundler
- Dart Sass (`dartsass-rails`) with watch mode via `Procfile.dev`
- **BEM** naming convention for all CSS classes; no element-of-element (`.block__el__subelement` is invalid)
- Mobile-first layouts; use `@mixin mobile-responsive` for breakpoints; center elements on page
- SimpleForm for form generation; Premailer-Rails for inline email CSS

### Background Infrastructure

SolidQueue (jobs), SolidCache (caching), SolidCable (WebSockets) — all database-backed, no external services required.

### Feature Flags

Flipper is integrated. Check flags with `Flipper.enabled?(:feature_name)`. The Flipper UI is available at `/flipper` for admin users (protected by `IsAdmin` constraint).

### Code Style

- Single quotes preferred; no spaces inside array literal brackets (`.rubocop.yml`)
- Comments should be minimal — code should be self-documenting
- Tests use Minitest with Mocha for mocking/stubbing; fixtures are loaded for all tests and run in parallel
