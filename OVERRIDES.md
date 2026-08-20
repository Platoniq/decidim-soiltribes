# decidim-soiltribes — gem overrides

_Generated 2026-08-20. Currently on Decidim **0.31.4**._

This app patches files that live inside the decidim gems. `spec/lib/overrides_spec.rb` stores an MD5 of each upstream original, so the suite fails the moment upstream changes one — that is the signal that a local copy has drifted from the version it was forked from.

**5 guarded file(s).**

## Ruby classes (1)

Copied or patched via an `*Override` concern. Needs a real diff of upstream old-vs-new and the customisation re-applied.

| package | file | recorded checksum |
|---|---|---|
| `decidim-core` | `/app/helpers/decidim/layout_helper.rb` | `7941b929…` |

## Views (4)

Full copies of gem templates. Re-copy the 0.31 version and re-apply the local change.

| package | file | recorded checksum |
|---|---|---|
| `decidim-core` | `/app/views/layouts/decidim/_head_extra.html.erb` | `25642b42…` |
| `decidim-core` | `/app/views/devise/mailer/invitation_instructions.html.erb` | `b91d1abb…` |
| `decidim-core` | `/app/views/devise/mailer/invite_private_user.html.erb` | `f978eddb…` |
| `decidim-core` | `/app/views/devise/mailer/reset_password_instructions.html.erb` | `40e2a215…` |

## Override concerns

- `app/helpers/concerns/decidim/layout_helper_override.rb`

## Wiring

- `config/initializers/decidim_overrides.rb`

## For the 0.31 upgrade

Every guarded file has to be checked against 0.31. Three outcomes:

1. **Upstream unchanged** — only the checksum needs re-recording.
2. **Upstream renamed** — update the path in the spec as well (0.31 renames Answer→Response across forms/surveys).
3. **Upstream changed** — diff 0.30.x→0.31.4 and re-apply the local customisation.

Compare with:

```
gh api repos/decidim/decidim/contents/<package><file>?ref=v0.30.9 -q .sha
gh api repos/decidim/decidim/contents/<package><file>?ref=v0.31.4 -q .sha
```

Same sha = category 1. 404 on the 0.31 side = category 2.

Conventions worth following (from [decidim-barcelona](https://github.com/AjuntamentdeBarcelona/decidim-barcelona) `.agent/skills/decidim-overrides/SKILL.md`):

- `.include` when the concern **adds** methods, `.prepend` when it **replaces** them, so `super` still reaches upstream.
- decidim_awesome applies Deface overrides by virtual path, so they compose on top of app-level view copies — if a copied view renders differently than it reads, check for a Deface override before hunting a bug.

