# Changelog

## 0.14

### 0.14.0
- Spina Pro now requires Spina >= 2.21 (Tailwind CSS 4). Use 0.13 with older Spina versions
- Updated admin views for Tailwind CSS 4 (slash opacity, `shadow-xs`, `cursor-pointer` on plain buttons)
- Fixed admin routes ignoring `Spina.config.backend_path` (they were always mounted at `/admin/pro`)
- Fixed booting without Sprockets (Propshaft apps)
- Replaced the deprecated `ActiveSupport::Configurable` with a configuration object; `Spina::Pro.config`, `Spina::Pro.configure` and `Spina::Pro.<option>=` keep working
- Stimulus controllers are now part of Spina's Tailwind sources
- Message classes can customize forwarding with `forward_target`, `forward_subject` and `forward_email_headers`, and with a mail template named after the class; `MessageMailer.forward` accepts `to:`
- Message fields in the message modal use the model's attribute translations
- Fixed invalid markup in the message modal
- Rewrite rules require a `new_path` that is an absolute path or an http(s) URL; path-relative targets raise in Rails 8.1

## 0.13

### 0.13.0
- Open-sourced under the MIT license, removed licensing

## 0.12

### 0.12.0
- Added UI for spam messages

## 0.11

### 0.11.0
- Added Dutch translations
- Added config.track_not_found_errors (default: true)

## 0.10

### 0.10.3
- Added Dutch translations

### 0.10.2
- Fixed licensing bug

### 0.10.1
- Fixed UI bug when deleting drafts
- Temporarily disabled phoning home to spinacms.com (because of Apple and Heroku downtime)

### 0.10.0
- Updated ViewComponents Slots API to v3
- Spina Pro now requires Spina >= v2.15.0

## 0.9

### 0.9.3
- Fixed bug when creating new drafts

### 0.9.2
- Skip saving a revision if nothing changed
- Use update instead of destroy/insert on search documents

### 0.9.1
- Add the `inbox` class method to messages

### 0.9.0
- Added support for version history
- Refactored UI for drafts

## 0.8

### 0.8.1
- Fixed bug for page revisions without AttrJson::NestedAttributes

### 0.8.0
- Added support for page revisions (multiple drafts)

## 0.7

### 0.7.1
- Rename search methods to prevent naming collision

### 0.7.0
- Added support for Spina::Parts::Pro::Date/Datetime fields
- Added support for ordering pages based on Date/Datetime fields

## 0.6

### 0.6.0
- Multi-model support in global search
- UI bugfixes
- Added pagination to Rewrite Rules

## 0.5

### 0.5.0
- Updated inbox view template
- Fixed bug with Tailwind content
- Fixed UI bug with page search

## 0.4

### 0.4.1
- Fixed bug with expires_at DateTime parsing

### 0.4.0
- Licensing validation