# Contributing to Blueprint Touch

## Setting up Automated Builds (for Maintainers)

This repository uses Travis CI for automated Android APK builds and releases. To enable the automated uploads to GitHub Releases, follow these steps:

### 1. Create GitHub Personal Access Token
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a descriptive name like "Blueprint Touch Travis CI"
4. Select the following scopes:
   - `public_repo` (or `repo` if the repository is private)
   - `contents:write`
5. Click "Generate token" and copy the token

### 2. Configure Travis CI
1. Go to https://travis-ci.com/ and sign in with GitHub
2. Enable Travis CI for the `remixie/Blueprint-Touch` repository
3. Go to repository settings in Travis CI
4. Add a new environment variable:
   - Name: `GITHUB_TOKEN`
   - Value: (paste the token from step 1)
   - Display value in build log: **OFF** (keep it secure)

### 3. How it Works
- Every push to any branch triggers a build
- If the build succeeds, the APK is automatically uploaded to GitHub Releases
- The release is tagged as `continuous` and gets updated with each new build
- Users can always download the latest APK from the [Releases page](../../releases/tag/continuous)

### 4. Build Status
Once configured, you can see build status at: https://travis-ci.com/github/remixie/Blueprint-Touch

## Development Setup

To work on Blueprint Touch locally:

1. Install Flutter SDK
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Use `flutter run` to run on a device/emulator
5. Use `flutter build apk --release` to build a release APK locally

## Code Style
- Follow standard Flutter/Dart conventions
- Use `flutter analyze` to check for issues
- Test on both Android and iOS if possible