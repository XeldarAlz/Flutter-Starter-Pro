.PHONY: help setup clean gen watch test coverage lint format build-android build-ios build-web run-dev run-staging run-prod l10n analyze fix

# Default target
help: ## Show this help message
	@echo "Flutter Starter Pro - Available Commands"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "\033[36m%-20s\033[0m %s\n", "Target", "Description"} /^[a-zA-Z_-]+:.*?##/ { printf "\033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# Setup
setup: ## Initial project setup
	@echo "📦 Installing dependencies..."
	flutter pub get
	@echo "🔧 Running code generation..."
	dart run build_runner build --delete-conflicting-outputs
	@echo "✅ Setup complete!"

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	flutter clean
	rm -rf .dart_tool
	rm -rf build
	rm -rf coverage
	@echo "✅ Clean complete!"

# Code Generation
gen: ## Run code generation (one-time)
	dart run build_runner build --delete-conflicting-outputs

watch: ## Run code generation in watch mode
	dart run build_runner watch --delete-conflicting-outputs

# Testing
test: ## Run all tests
	flutter test

test-unit: ## Run unit tests only
	flutter test test/unit

test-widget: ## Run widget tests only
	flutter test test/widget

test-integration: ## Run integration tests
	flutter test integration_test

coverage: ## Run tests with coverage
	flutter test --coverage
	@echo "📊 Coverage report generated at coverage/lcov.info"
	@echo "Run 'genhtml coverage/lcov.info -o coverage/html' to generate HTML report"

coverage-html: coverage ## Generate HTML coverage report
	genhtml coverage/lcov.info -o coverage/html
	@echo "📊 HTML report generated at coverage/html/index.html"

# Code Quality
lint: ## Run linter
	flutter analyze

format: ## Format code
	dart format .

format-check: ## Check code formatting
	dart format --output=none --set-exit-if-changed .

analyze: ## Run analyzer with fatal warnings
	flutter analyze --fatal-warnings

fix: ## Apply automatic fixes
	dart fix --apply

# Build - Development
run-dev: ## Run development build
	flutter run -t lib/main_dev.dart

run-dev-android: ## Run development build on Android with flavor
	flutter run --flavor dev -t lib/main_dev.dart

run-dev-ios: ## Run development build on iOS with flavor
	flutter run --flavor dev -t lib/main_dev.dart

# Build - Staging
run-staging: ## Run staging build
	flutter run -t lib/main_staging.dart

run-staging-android: ## Run staging build on Android with flavor
	flutter run --flavor staging -t lib/main_staging.dart

# Build - Production
run-prod: ## Run production build
	flutter run -t lib/main_prod.dart

run-prod-release: ## Run production build in release mode
	flutter run --release -t lib/main_prod.dart

# Build Artifacts
build-android-dev: ## Build Android APK (development)
	flutter build apk -t lib/main_dev.dart

build-android-staging: ## Build Android APK (staging)
	flutter build apk -t lib/main_staging.dart

build-android-prod: ## Build Android APK (production)
	flutter build apk --release -t lib/main_prod.dart

build-android-bundle: ## Build Android App Bundle (production)
	flutter build appbundle --release -t lib/main_prod.dart

build-ios-dev: ## Build iOS (development)
	flutter build ios -t lib/main_dev.dart --no-codesign

build-ios-prod: ## Build iOS (production)
	flutter build ios --release -t lib/main_prod.dart

build-web: ## Build Web (production)
	flutter build web --release -t lib/main_prod.dart

# Localization
l10n: ## Generate localization files
	flutter gen-l10n

# Dependencies
deps: ## Get dependencies
	flutter pub get

deps-upgrade: ## Upgrade dependencies
	flutter pub upgrade

deps-outdated: ## Check for outdated dependencies
	flutter pub outdated

# Git hooks (if using lefthook)
hooks-install: ## Install git hooks
	lefthook install

hooks-uninstall: ## Uninstall git hooks
	lefthook uninstall

# Utilities
doctor: ## Run Flutter doctor
	flutter doctor -v

devices: ## List available devices
	flutter devices

icons: ## Generate app icons (requires flutter_launcher_icons)
	dart run flutter_launcher_icons

splash: ## Generate splash screen (requires flutter_native_splash)
	dart run flutter_native_splash:create
