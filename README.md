# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version - 3.4.5

- System dependencies - N/A

- Configuration

- Database creation - Postgres

- Database initialization

- How to run the test suite - bin/rails test, bin/rails test:system

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

## Architecture

This is a modular monolith. We have three modules:

- public - core application functionality
- analytics - user behavior insights
- monitoring - observing the health of the system

Modules expose functionality through service objects. Service objects should be used in controllers, not other service objects or models.
