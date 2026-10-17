# Publishing Moyasar Flutter SDK to pub.dev

This doc describes how to release new versions to pub.dev using GitHub Actions (no long-lived secrets; uses OIDC).

---

## One-time setup (repo owner / person with pub.dev access)

### 1. Enable automated publishing on pub.dev

1. Sign in at [pub.dev](https://pub.dev) with the Google account that has **uploader** (or publisher admin) access to the `moyasar` package.
2. Open the package page: **https://pub.dev/packages/moyasar**
3. Go to the **Admin** tab.
4. Find **Automated publishing** and click **Enable publishing from GitHub Actions**.
5. Configure:
   - **GitHub repository:** `moyasar/moyasar-flutter` (or your org/repo).
   - **Tag pattern:** `v{{version}}`  
     Only runs triggered by a **tag push** matching this pattern will be allowed to publish.  
     Example: tag `v3.0.0` publishes version `3.0.0` (and `pubspec.yaml` must already have `version: 3.0.0`).
6. Save.

---

## Releasing a new version (anyone who can push tags)

**Important:** The workflow publishes **only if the tag points to a commit on `main`**. If someone pushes a tag from a branch or before the PR is merged, the action will fail and nothing is published.

1. **Prepare and validate the release**
   - Update `pubspec.yaml`, the SDK `version` in `lib/src/moyasar.dart`, and `CHANGELOG.md` together.
   - Run `flutter pub get` to refresh the package and example lockfiles.
   - Run `flutter test` at the package root and in `example/`. These tests use mocked HTTP and do not submit payments.
   - Run `flutter analyze --no-fatal-infos`. Existing informational lints are reported; warnings and errors still fail validation.
   - Run `flutter pub publish --dry-run` and inspect the archive. Resolve package warnings; commit the release changes before the final dry run so the Git-state warning is cleared.
   - For Apple Pay changes, complete the physical-device scenarios listed in `docs/apple_pay_investigation.md`. Widget tests and Swift type checks do not exercise real PassKit authorization.
   - The prepared patch release is `3.0.6`; see `docs/releases/3.0.6.md` for its validation record.

2. **Merge to `main`**  
   Get the release commit merged to `main` (e.g. via PR).

3. **Create and push the tag from `main`**  
   Checkout main, pull, then tag the commit and push the tag:
   ```bash
   git checkout main
   git pull origin main
   git tag v3.0.6
   git push origin v3.0.6
   ```

4. **GitHub Action runs**  
   The workflow checks that the tag is on `main`, verifies the version, and runs package/example tests and analysis. It then validates the package and publishes to pub.dev (no manual token; uses OIDC).

5. **Check result**  
   - GitHub: Actions tab → “Publish to pub.dev” run.  
   - pub.dev: package page and **Audit log** to see the publication.

---

## Summary

| What |
|------|
| Enable “Publishing from GitHub Actions” on pub.dev with repo + tag pattern `v{{version}}`. Optionally set tag protection or environment. |
| Add/merge the workflow (e.g. via PR). To release: update `version` in pubspec, commit, push, then `git tag vX.Y.Z` and `git push origin vX.Y.Z`. |

No pub.dev token or API key is stored in GitHub; authentication uses OIDC (short-lived token from GitHub).
