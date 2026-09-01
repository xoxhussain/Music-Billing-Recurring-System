# Test Project

A Ruby on Rails test project developed as part of the internship assessment. The project is related to Music Billing and Recurring System and it implements user authentication, role management, invitations, subscriptions, plans, features, usage tracking, payment authorization, and transactions according to the approved project design.

## Tech Stack

* Ruby
* Ruby on Rails
* SQLite
* Devise
* HTML / ERB
* Git & GitHub

## Project Structure

The project is being developed incrementally over a 7-day implementation plan.

Each day's work is maintained in a separate Git branch:

* `day1` — Day 1 implementation
* `day2` — Day 2 implementation
* `day3` — Day 3 implementation
* `day4` — Day 4 implementation
* `day5` — Day 5 implementation
* `day6` — Day 6 implementation
* `day7` — Day 7 implementation

The `main` branch will contain the final approved version.

## Day 1 — Initial Setup & Core Implementation

### Completed

* Created the Rails project
* Set up the initial database structure
* Created the core models and migrations
* Implemented User and Role relationship
* Configured Devise authentication
* Implemented Invitation model
* Added invitation relationship with User
* Added protected invitation routes
* Implemented invitation creation form
* Added invitation token generation
* Added invitation expiration time
* Tested user registration/login through Devise
* Tested authenticated access to `/invitations/new`
* Tested invitation creation and database persistence

### Authentication Flow

Unauthenticated users attempting to access protected pages are redirected to the Devise login page.

Example:

```text
/invitations/new
       ↓
Not authenticated
       ↓
/users/sign_in
       ↓
Login
       ↓
/invitations/new
```

### Invitation Flow

```text
Authenticated User
       ↓
/invitations/new
       ↓
Enter recipient email
       ↓
Submit invitation
       ↓
Generate token
       ↓
Set expiration time
       ↓
Save Invitation
```

## Database Entities

The project currently includes the following core entities:

* User
* Role
* Invitation
* PaymentAuthorization
* Plan
* Feature
* PlanFeature
* Subscription
* Subscription_status
* UsageEntry
* Transaction

## Running the Project

Install dependencies:

```bash
bundle install
```

Run database migrations:

```bash
ruby bin/rails db:migrate
```

Start the Rails server:

```bash
ruby bin/rails server
```

The application will be available at:

```text
http://localhost:3000
```

## Testing

Rails console can be used to verify records:

```bash
ruby bin/rails console
```

Example:

```ruby
User.all
Role.all
Invitation.all
```

## 7-Day Implementation Plan

### Day 1

Initial project setup, authentication, roles, invitations, and core database implementation.

### Day 2

*To be completed.*

### Day 3

*To be completed.*

### Day 4

*To be completed.*

### Day 5

*To be completed.*

### Day 6

*To be completed.*

### Day 7

*Final testing, cleanup, documentation, and approval.*

## Status

**Day 1 — Completed**

Further implementation will be added incrementally throughout the 7-day development plan.
