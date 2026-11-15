# Marswalk project maintenance

Preserve the existing Site ID and access settings. Do not expose credentials or private workspace files.

The user requires a complete, current project ZIP with every addition/change.
- Run `npm run build` before every publication; this runs tests and rebuilds the ZIP.
- Run `npm run verify:bundle` before packaging. Never publish a stale ZIP.
- Keep the About-page project-download link and source metadata working.
- The download is `dist/downloads/Marswalk-project.zip`; exclude it and other generated outputs from its own contents.
- Use `npm run watch:zip` for continuously updated local archives while editing. Stop that process before final commit/package.
- Configure `git config core.hooksPath .githooks` in new checkouts. The pre-commit hook regenerates and stages the ZIP as a second safeguard.
- Update README, docs and CHANGELOG when behavior or limitations change.
- A downloaded ZIP is an immutable snapshot. Only the hosted current-download endpoint is replaced on publication.

Preserve scientific distinctions: route grades are recorded track grades, inferred joins are not certified traversable terrain, panoramas have approximate historical positions, and global context does not add science POIs outside Jezero.
