#!/usr/bin/env bash
# evals/lint-agnostic.sh
#
# Stack-neutral structural lint per paired-scaffold-capability spec §C.
#
#   R1   product-name grep            — agents/** + skills/**          (FAIL)
#   R2   stack-token placement        — agents/** + skills/**          (FAIL)
#        bidirectional; prose-only (fenced code / quoted lines / inline
#        backticks stripped before grep).
#   R3   no-fork / drift              — {canvas_path} ↔ {shared_path}   (FAIL)
#        content duplication + #filePath resource loading when
#        sharing_mechanism: spm-local. Runs regardless of scaffold_state.
#   R4   skills do not hardcode paths — skills/**                      (WARN)
#   R5   specialist scaffold anchor   — agents/*-engineer.md           (FAIL)
#        exactly one fenced ```scaffold-commands block; required keys present.
#   R6   kit reference                 — agents/** + skills/**          (FAIL)
#        any file with artifact:/artifacts: frontmatter must reference
#        the named template(s) or artifacts/kit/studio.css; named
#        templates must exist in artifacts/templates/.
#   R7   graph block validation        — skills/**                      (FAIL)
#        exactly one fenced ```graph block per graph-declaring skill;
#        agents resolve; edges reference declared nodes; loops bounded;
#        fan-out members independent; human nodes carry decides:.
#   R7.b six-functions coverage        — skills per six-functions.map   (FAIL)
#        artifact-producing graphs cover all six functions + slop gate.
#   R7.c executor conformance          — skills/*/workflow.js           (FAIL)
#        executor roster must include every graph agent; meta present.
#   R7.d refutation nodes              — skills/**                      (FAIL)
#        a skill with any refute* node: (a) its SKILL.md cites
#        ${user_config.adversary_model}; (b) its workflow.js defines
#        `const ADVERSARY_MODEL =` and `async function refute(`; (c) REFUTE_SCHEMA
#        and ADVERSARY_MODEL appear only in their const lines and inside
#        refute(); (d) refute() is called at least once; (e) its SKILL.md
#        passes `adversaryModel` to the executor.
#   R8   auto-contract stub            — skills/**                      (FAIL)
#        any skill mentioning --auto must reference the Auto-Mode
#        Safety Contract in memory/orchestration.md (no inline forks).
#   R9   pattern-entry structure       — patterns/**                    (FAIL)
#        every entry carries Problem/Standard/Verified + Solution/
#        Why this shape/Prevents sections (per patterns/README.md).
#   R10  memory citations name tier    — agents/** + skills/**          (FAIL)
#        a bare `memory/…` citation resolves only inside the plugin root.
#   R11  agent model & effort          — agents/*.md                    (FAIL)
#        every agent's frontmatter model/effort matches its row in the
#        memory/orchestration.md § Model and effort table (named row, else
#        the single `every other agent` row; `—` = no effort: key); the table
#        must parse; verdict agents (pm cd de) opus|fable at high+; no prose
#        model pins (claude-<m>-<n>, [OPUS], `model: <name>`) in agent bodies,
#        SKILL.md, workflow.js.
#   R12  eval coverage                 — agents/ + skills/ vs evals/    (FAIL)
#        every agent has a `## <Name> —` heading in an evals/*.eval.md (name
#        lowercased, spaces→hyphens) or is the file's singular `Agent:` line;
#        every skill has a `## <name>` heading in evals/skills.eval.md.
#   IBR  included-by-reference         — project-level                  (FAIL)
#        the invariant the design exists to protect.
#        Runs regardless of scaffold_state.
#
# Usage:
#   lint-agnostic.sh                          plugin-internal (R1, R2, R4, R5)
#   lint-agnostic.sh --project <path>         + project-level (R3, IBR)
#
# Exit codes:
#   0  all PASS (WARNs allowed)
#   1  at least one FAIL
#   2  bad invocation / missing input file
#
# Dependencies: bash 3.2+, awk, grep, find, sed, sort, sha256sum (or shasum -a 256).
# Avoids `mapfile` and `declare -A` (bash 4+ only) so it runs on stock macOS.

set -uo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLUGIN_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

PRODUCT_DENY="$SCRIPT_DIR/product-tokens.deny"
STACK_ALLOW="$SCRIPT_DIR/stack-tokens.allow"

PROJECT_ROOT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      [[ $# -ge 2 ]] || { echo "--project requires a path" >&2; exit 2; }
      PROJECT_ROOT="$( cd "$2" 2>/dev/null && pwd )" || {
        echo "--project: not a directory: $2" >&2; exit 2;
      }
      shift 2
      ;;
    -h|--help)
      awk '/^# Usage:/,/^# Exit codes:/ { print }' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)
      echo "unknown arg: $1" >&2; exit 2 ;;
  esac
done

[[ -r "$PRODUCT_DENY" ]] || { echo "missing: $PRODUCT_DENY" >&2; exit 2; }
[[ -r "$STACK_ALLOW" ]]  || { echo "missing: $STACK_ALLOW" >&2; exit 2; }

if command -v sha256sum >/dev/null 2>&1; then
  HASH_CMD=(sha256sum)
elif command -v shasum >/dev/null 2>&1; then
  HASH_CMD=(shasum -a 256)
else
  HASH_CMD=()
fi

FAIL_COUNT=0
WARN_COUNT=0
fail()    { printf "FAIL  %s\n" "$*"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
warn()    { printf "WARN  %s\n" "$*"; WARN_COUNT=$((WARN_COUNT + 1)); }
info()    { printf "      %s\n" "$*"; }
section() { printf "\n── %s ──\n" "$*"; }

AGENT_FILES=()
while IFS= read -r line; do AGENT_FILES+=("$line"); done < <(find "$PLUGIN_ROOT/agents" -type f -name '*.md' 2>/dev/null | sort)
SKILL_FILES=()
while IFS= read -r line; do SKILL_FILES+=("$line"); done < <(find "$PLUGIN_ROOT/skills" -type f -name 'SKILL.md' 2>/dev/null | sort)

# ── helpers ───────────────────────────────────────────────────────────────────

frontmatter_stack() {
  awk '
    BEGIN { in_fm = 0; seen = 0 }
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm && /^---[[:space:]]*$/ { exit }
    in_fm && /^stack:[[:space:]]*/ {
      sub(/^stack:[[:space:]]*/, "")
      sub(/[[:space:]]*$/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      print
      seen = 1
      exit
    }
  ' "$1"
}

# Prose-only surface, line-aligned with source (per spec §C R2). Strips
# fenced code blocks, leading "> " quoted lines, and inline `…` spans.
# Frontmatter is NOT stripped — `description:` text counts as prose for R2.
#
# CommonMark-correct fence handling: when inside a fence, only a bare ```
# (no info string) closes it; nested ```yaml inside a ```markdown block is
# content of the outer fence, not a second fence — so the lint surface
# stays blank through the whole outer block.
prose_only() {
  awk '
    BEGIN { in_fence = 0 }
    in_fence && /^[[:space:]]*```[[:space:]]*$/ { in_fence = 0; print ""; next }
    !in_fence && /^[[:space:]]*```/ { in_fence = 1; print ""; next }
    in_fence { print ""; next }
    /^>[[:space:]]/ { print ""; next }
    {
      line = $0
      while (match(line, /`[^`]*`/)) {
        line = substr(line, 1, RSTART - 1) substr(line, RSTART + RLENGTH)
      }
      print line
    }
  ' "$1"
}

rel_plugin() { printf '%s' "${1#$PLUGIN_ROOT/}"; }

# Strip imports + normalize whitespace, then hash. Empty input → empty hash.
normalized_hash() {
  local file="$1"
  awk '
    /^[[:space:]]*import[[:space:]]/ { next }
    /^[[:space:]]*from[[:space:]]/ { next }
    { gsub(/[[:space:]]+/, " "); sub(/^[[:space:]]+/, ""); sub(/[[:space:]]+$/, ""); if (length($0)) print }
  ' "$file" | "${HASH_CMD[@]}" | awk '{print $1}'
}

# ── R1 — product-name grep ────────────────────────────────────────────────────

section "R1 · product-name grep — agents/** + skills/**"

DENY_TOKENS=()
while IFS= read -r line; do DENY_TOKENS+=("$line"); done < <(grep -v '^[[:space:]]*#' "$PRODUCT_DENY" | sed '/^[[:space:]]*$/d')

if [[ ${#DENY_TOKENS[@]} -eq 0 ]]; then
  info "no deny tokens configured — skipping R1"
else
  r1_hits=0
  for f in "${AGENT_FILES[@]}" "${SKILL_FILES[@]}"; do
    [[ -r "$f" ]] || continue
    rel="$(rel_plugin "$f")"
    for token in "${DENY_TOKENS[@]}"; do
      while IFS=: read -r lineno _; do
        [[ -n "$lineno" ]] || continue
        fail "$rel:$lineno — denied product token \"$token\""
        r1_hits=$((r1_hits + 1))
      done < <(grep -n -F -- "$token" "$f" 2>/dev/null || true)
    done
  done
  [[ $r1_hits -eq 0 ]] && info "no product-token leaks"
fi

# ── R2 — stack-token placement (bidirectional, prose-only) ────────────────────

section "R2 · stack-token placement — bidirectional, prose-only"

# Parallel arrays (bash 3.2 — no associative arrays). Index in STACKS
# corresponds to index in STACK_TOKEN_LISTS.
STACKS=()
STACK_TOKEN_LISTS=()

while IFS= read -r raw; do
  [[ "$raw" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${raw// }" ]] && continue
  if [[ "$raw" =~ ^([a-zA-Z0-9_-]+):[[:space:]]*(.*)$ ]]; then
    STACKS+=("${BASH_REMATCH[1]}")
    STACK_TOKEN_LISTS+=("${BASH_REMATCH[2]}")
  fi
done < "$STACK_ALLOW"

if [[ ${#STACKS[@]} -eq 0 ]]; then
  info "no stack tokens configured — skipping R2"
else
  r2_hits=0
  for f in "${AGENT_FILES[@]}" "${SKILL_FILES[@]}"; do
    [[ -r "$f" ]] || continue
    rel="$(rel_plugin "$f")"
    file_stack="$(frontmatter_stack "$f")"
    prose="$(prose_only "$f")"

    for i in "${!STACKS[@]}"; do
      stack="${STACKS[$i]}"
      IFS=',' read -r -a tokens <<< "${STACK_TOKEN_LISTS[$i]}"
      for raw_tok in "${tokens[@]}"; do
        tok="${raw_tok#"${raw_tok%%[![:space:]]*}"}"
        tok="${tok%"${tok##*[![:space:]]}"}"
        [[ -z "$tok" ]] && continue
        while IFS=: read -r lineno _; do
          [[ -n "$lineno" ]] || continue
          if [[ -z "$file_stack" ]]; then
            fail "$rel:$lineno — stack token \"$tok\" (stack:$stack) in file with no stack: frontmatter (R2.b)"
            r2_hits=$((r2_hits + 1))
          elif [[ "$file_stack" != "$stack" ]]; then
            fail "$rel:$lineno — stack token \"$tok\" (stack:$stack) in file declaring stack:$file_stack (R2.c cross-contamination)"
            r2_hits=$((r2_hits + 1))
          fi
        done < <(printf '%s\n' "$prose" | grep -n -F -- "$tok" 2>/dev/null || true)
      done
    done
  done
  [[ $r2_hits -eq 0 ]] && info "no stack-token leaks"
fi

# ── R4 — skills do not hardcode paths (WARN) ─────────────────────────────────

section "R4 · skills do not hardcode paths"

# Per spec the regex is loose; we narrow to actual-file-path likelihood:
# require either a recognizable file extension OR a leading ./ or ../ to
# distinguish "code/canvas/foo.swift" (real path) from "agent/skill" or
# "Pass/fail" (slash-separated word lists in prose).
EXEMPT_RE='^(agents/|skills/|evals/|templates/|memory/|\.claude/|\.\./|http)'
PATH_RE='(\.{0,2}/)?[a-zA-Z0-9_.-]+(/[a-zA-Z0-9_.-]+)+'
PATH_NARROW_RE='\.(md|swift|ts|tsx|jsx|js|mjs|cjs|json|yml|yaml|html|css|scss|sh|bash|py|kt|gradle|toml|xml|plist|sql|graphql|gql|env|cfg|ini|txt|pbxproj|lock)([^a-zA-Z0-9]|$)|^(\.\./|\./|/)'

r4_hits=0
for f in "${SKILL_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  prose="$(prose_only "$f")"

  while IFS= read -r line; do
    lineno="${line%%:*}"
    rest="${line#*:}"
    [[ "$rest" == *"{"*"}"* ]] && continue
    if [[ "$rest" =~ ($PATH_RE) ]]; then
      candidate="${BASH_REMATCH[1]}"
      candidate="${candidate#[(\[\"\'<]}"
      candidate="${candidate%[)\]\"\'>,.;]}"
      [[ "$candidate" =~ $EXEMPT_RE ]] && continue
      [[ "$candidate" == *"{"*"}"* ]] && continue
      # Narrow: require an extension or relative-path prefix
      [[ "$candidate" =~ $PATH_NARROW_RE ]] || continue
      # Re-check exempt after narrowing (./.claude/... etc.)
      [[ "$candidate" =~ $EXEMPT_RE ]] && continue
      warn "$rel:$lineno — bare path \"$candidate\" — prefer manifest-key reference (R4)"
      r4_hits=$((r4_hits + 1))
    fi
  done < <(printf '%s\n' "$prose" | grep -nE "$PATH_RE" 2>/dev/null || true)
done
[[ $r4_hits -eq 0 ]] && info "no bare-path WARNs"

# ── R5 — specialist scaffold-commands anchor ──────────────────────────────────

section "R5 · specialist scaffold-commands anchor"

REQUIRED_KEYS=(generate install build test)
OPTIONAL_KEYS=(prototype shared_test)

r5_hits=0
SPECIALIST_FILES=()
while IFS= read -r line; do SPECIALIST_FILES+=("$line"); done < <(find "$PLUGIN_ROOT/agents" -type f -name '*-engineer.md' 2>/dev/null | sort)

if [[ ${#SPECIALIST_FILES[@]} -eq 0 ]]; then
  info "no engineer specialists found — skipping R5"
else
  for f in "${SPECIALIST_FILES[@]}"; do
    rel="$(rel_plugin "$f")"
    blocks="$(awk '/^[[:space:]]*```scaffold-commands[[:space:]]*$/ { count++ } END { print count + 0 }' "$f")"

    if [[ "$blocks" -eq 0 ]]; then
      fail "$rel — missing required \`\`\`scaffold-commands block (R5)"
      r5_hits=$((r5_hits + 1)); continue
    fi
    if [[ "$blocks" -gt 1 ]]; then
      fail "$rel — found $blocks \`\`\`scaffold-commands blocks; exactly one required (R5)"
      r5_hits=$((r5_hits + 1)); continue
    fi

    # BSD awk on macOS lacks 3-arg match() — extract via match() + substr().
    keys="$(awk '
      BEGIN { in_block = 0 }
      /^[[:space:]]*```scaffold-commands[[:space:]]*$/ { in_block = 1; next }
      in_block && /^[[:space:]]*```[[:space:]]*$/ { in_block = 0; next }
      in_block {
        if (match($0, /^[[:space:]]*[a-z_]+[[:space:]]*:/)) {
          s = substr($0, RSTART, RLENGTH)
          sub(/^[[:space:]]+/, "", s)
          sub(/[[:space:]]*:[[:space:]]*$/, "", s)
          print s
        }
      }
    ' "$f")"

    missing=()
    for k in "${REQUIRED_KEYS[@]}"; do
      grep -qx -- "$k" <<< "$keys" || missing+=("$k")
    done
    if [[ ${#missing[@]} -gt 0 ]]; then
      fail "$rel — scaffold-commands missing required keys: ${missing[*]} (R5)"
      r5_hits=$((r5_hits + 1))
    fi

    while IFS= read -r k; do
      [[ -z "$k" ]] && continue
      known=0
      for rk in "${REQUIRED_KEYS[@]}" "${OPTIONAL_KEYS[@]}"; do
        [[ "$k" == "$rk" ]] && { known=1; break; }
      done
      [[ $known -eq 0 ]] && warn "$rel — scaffold-commands has unknown key \"$k\""
    done <<< "$keys"
  done
  [[ $r5_hits -eq 0 ]] && info "all ${#SPECIALIST_FILES[@]} specialists have valid scaffold-commands"
fi

# ── R6 — kit reference (artifact production) ──────────────────────────────────

section "R6 · kit reference — agents/** + skills/**"

# Parse the artifact: or artifacts: [a, b] frontmatter key from a file.
# Emits one artifact name per output line.
frontmatter_artifacts() {
  awk '
    BEGIN { in_fm = 0 }
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm && /^---[[:space:]]*$/ { exit }
    in_fm && /^artifact:[[:space:]]*/ {
      sub(/^artifact:[[:space:]]*/, "")
      sub(/[[:space:]]*$/, "")
      gsub(/^["'\'']|["'\'']$/, "")
      if (length($0)) print
      next
    }
    in_fm && /^artifacts:[[:space:]]*\[/ {
      sub(/^artifacts:[[:space:]]*\[/, "")
      sub(/\][[:space:]]*$/, "")
      n = split($0, arr, /,[[:space:]]*/)
      for (i = 1; i <= n; i++) {
        gsub(/[[:space:]]+/, "", arr[i])
        gsub(/^["'\'']|["'\'']$/, "", arr[i])
        if (length(arr[i])) print arr[i]
      }
    }
  ' "$1"
}

r6_hits=0
r6_files_checked=0
ALL_ARTIFACT_FILES=("${AGENT_FILES[@]}" "${SKILL_FILES[@]}")
for f in "${ALL_ARTIFACT_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  artifacts="$(frontmatter_artifacts "$f")"
  [[ -z "$artifacts" ]] && continue
  rel="$(rel_plugin "$f")"
  r6_files_checked=$((r6_files_checked + 1))

  has_kit_ref=0
  grep -qF "artifacts/kit/studio.css" "$f" && has_kit_ref=1

  while IFS= read -r artifact_name; do
    [[ -z "$artifact_name" ]] && continue

    template_rel="artifacts/templates/${artifact_name}.html"
    template_abs="$PLUGIN_ROOT/$template_rel"

    if ! grep -qF "$template_rel" "$f" && [[ $has_kit_ref -eq 0 ]]; then
      fail "$rel — declares artifact: $artifact_name but body does not reference $template_rel or artifacts/kit/studio.css (R6.a)"
      r6_hits=$((r6_hits + 1))
    fi

    if [[ ! -r "$template_abs" ]]; then
      fail "$rel — declares artifact: $artifact_name but $template_rel does not exist (R6.b)"
      r6_hits=$((r6_hits + 1))
    fi
  done <<< "$artifacts"
done

if [[ $r6_files_checked -eq 0 ]]; then
  info "no files declare artifact: — R6 N/A"
elif [[ $r6_hits -eq 0 ]]; then
  info "all $r6_files_checked artifact-declaring files reference their kit templates"
fi

# ── R7 — graph block validation ───────────────────────────────────────────────

section "R7 · graph blocks — skills/**"

SIX_MAP="$SCRIPT_DIR/six-functions.map"

# Parse the ```graph block of one SKILL.md. Emits structured lines:
#   BLOCKS <n>        number of ```graph fences
#   SKILL <name>      value of the skill: line
#   COST 1            cost: line present
#   ERR <message>     structural failure
#   AGENT <name>      each agent: node
#   REFUTE <id>       each node whose id begins with `refute` (R7.d)
#   GATESPEC <text>   each gate node's full spec (for R7.b gate/slop coverage)
graph_scan() {
  awk '
    BEGIN { in_g = 0; blocks = 0; mode = ""; cost = 0; skillname = "" }
    /^[[:space:]]*```graph[[:space:]]*$/ { blocks++; in_g = 1; mode = ""; next }
    in_g && /^[[:space:]]*```[[:space:]]*$/ { in_g = 0; next }
    !in_g { next }
    {
      line = $0
      sub(/#.*$/, "", line)
      if (line ~ /^[[:space:]]*$/) next

      if (line ~ /^skill:[[:space:]]*/) {
        skillname = line; sub(/^skill:[[:space:]]*/, "", skillname); sub(/[[:space:]]*$/, "", skillname)
        next
      }
      if (line ~ /^cost:/) { cost = 1; next }
      if (line ~ /^nodes:[[:space:]]*$/) { mode = "nodes"; next }
      if (line ~ /^edges:[[:space:]]*$/) { mode = "edges"; next }

      if (mode == "nodes") {
        s = line; sub(/^[[:space:]]+/, "", s)
        id = s; sub(/[[:space:]].*$/, "", id)
        spec = s; sub(/^[^[:space:]]+[[:space:]]*/, "", spec)
        if (id == "") next
        declared[id] = 1
        if (id ~ /^refute/) print "REFUTE " id
        if (spec ~ /agent:/) {
          a = spec; sub(/^.*agent:/, "", a); sub(/[[:space:]].*$/, "", a)
          print "AGENT " a
        } else if (spec ~ /^human/) {
          if (spec !~ /decides:/) print "ERR human node \"" id "\" has no decides: annotation"
        }
        if (spec ~ /(^|[[:space:]])gate/) print "GATESPEC " id " " spec
        next
      }

      if (mode == "edges") {
        if (line ~ /loop/ && line !~ /loop[[:space:]]+max:[0-9]+/) {
          print "ERR unbounded loop (loop without max:N): " line
        }
        e = line
        sub(/^[[:space:]]+/, "", e)
        gsub(/if:[^[:space:]]+/, "", e)
        gsub(/loop[[:space:]]+max:[0-9]+/, "", e)
        gsub(/[[:space:]]loop([[:space:]]|$)/, " ", e)
        n = split(e, seg, /->/)
        for (i = 1; i <= n; i++) {
          s = seg[i]
          gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
          if (s == "") continue
          if (s ~ /^\{/) {
            gsub(/[{}]/, "", s)
            m = split(s, mem, /,/)
            grp = ""
            for (j = 1; j <= m; j++) {
              gsub(/^[[:space:]]+|[[:space:]]+$/, "", mem[j])
              if (mem[j] == "") continue
              eps[++ep_n] = mem[j]
              grp = grp (grp == "" ? "" : "|") mem[j]
              segid[i] = "GROUP"
            }
            groups[++grp_n] = grp
          } else {
            eps[++ep_n] = s
            segid[i] = s
          }
        }
        # simple consecutive single->single edges, for fan-out independence
        for (i = 1; i < n; i++) {
          if (segid[i] != "GROUP" && segid[i+1] != "GROUP" && segid[i] != "" && segid[i+1] != "") {
            sedges[++se_n] = segid[i] "|" segid[i+1]
          }
          segid[i] = ""
        }
        segid[n] = ""
        next
      }
    }
    END {
      print "BLOCKS " blocks
      if (blocks == 0) exit
      if (skillname != "") print "SKILL " skillname
      else print "ERR graph block missing skill: line"
      if (cost) print "COST 1"
      else print "ERR graph block missing cost: line"
      for (i = 1; i <= ep_n; i++) {
        if (!(eps[i] in declared)) print "ERR edge references undeclared node \"" eps[i] "\""
      }
      for (g = 1; g <= grp_n; g++) {
        m = split(groups[g], mem, /\|/)
        for (a = 1; a <= m; a++) for (b = 1; b <= m; b++) {
          if (a == b) continue
          for (s = 1; s <= se_n; s++) {
            if (sedges[s] == mem[a] "|" mem[b])
              print "ERR fan-out members \"" mem[a] "\" and \"" mem[b] "\" have an edge between them — not independent"
          }
        }
      }
    }
  ' "$1"
}

# Scan one workflow.js for the refutation helper (R7.d.c, R7.d.d). The helper is
# `async function refute(prompt, opts) {` at column 0, closed by the first `}` at
# column 0. Emits:
#   DEF <lineno>             the helper's definition line (absent if not defined)
#   STRAY <lineno>:<text>    a REFUTE_SCHEMA / ADVERSARY_MODEL reference outside
#                            the helper body, other than a `const` definition line
#                            or a `//` comment
#   CALLS <n>                `refute(` call sites outside the helper body
# A trailing `// …` comment is ignored when judging a line (a `//` glued to a
# non-space, as in a URL, is not a comment). Block comments are not special-cased.
refute_scan() {
  awk '
    BEGIN { in_fn = 0; def = 0; calls = 0 }
    {
      if (!def && $0 ~ /^async function refute\(/) { def = NR; in_fn = 1; print "DEF " NR }
      code = $0
      sub(/(^|[ \t])\/\/.*$/, "", code)
      if (!in_fn) {
        if (code ~ /(^|[^A-Za-z0-9_$.])refute\(/) calls++
        if (code ~ /REFUTE_SCHEMA|ADVERSARY_MODEL/) {
          rest = code
          is_def = sub(/^[ \t]*const[ \t]+(REFUTE_SCHEMA|ADVERSARY_MODEL)[ \t]*=/, "", rest)
          if (!(is_def && rest !~ /REFUTE_SCHEMA|ADVERSARY_MODEL/)) print "STRAY " NR ":" $0
        }
      }
      if (in_fn && NR != def && $0 ~ /^}/) in_fn = 0
    }
    END { print "CALLS " calls }
  ' "$1"
}

# Governed skills + function→agents lines from six-functions.map
GOVERNED_SKILLS=""
if [[ -r "$SIX_MAP" ]]; then
  GOVERNED_SKILLS="$(grep -E '^skills:' "$SIX_MAP" | sed 's/^skills:[[:space:]]*//; s/,/ /g')"
fi

r7_hits=0
r7_graphs=0
for f in "${SKILL_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  skill_dir="$(basename "$(dirname "$f")")"

  scan="$(graph_scan "$f")"
  blocks="$(printf '%s\n' "$scan" | awk '/^BLOCKS /{print $2; exit}')"
  blocks="${blocks:-0}"

  is_governed=0
  for g in $GOVERNED_SKILLS; do [[ "$g" == "$skill_dir" ]] && is_governed=1; done

  if [[ "$blocks" -eq 0 ]]; then
    if [[ $is_governed -eq 1 ]]; then
      fail "$rel — governed by six-functions.map but has no \`\`\`graph block (R7.b)"
      r7_hits=$((r7_hits + 1))
    fi
    continue
  fi
  r7_graphs=$((r7_graphs + 1))

  if [[ "$blocks" -gt 1 ]]; then
    fail "$rel — found $blocks \`\`\`graph blocks; exactly one required (R7)"
    r7_hits=$((r7_hits + 1))
  fi

  gskill="$(printf '%s\n' "$scan" | awk '/^SKILL /{print $2; exit}')"
  if [[ -n "$gskill" && "$gskill" != "$skill_dir" ]]; then
    fail "$rel — graph declares skill: $gskill but lives in skills/$skill_dir/ (R7)"
    r7_hits=$((r7_hits + 1))
  fi

  while IFS= read -r e; do
    [[ "$e" == ERR* ]] || continue
    fail "$rel — ${e#ERR } (R7)"
    r7_hits=$((r7_hits + 1))
  done <<< "$scan"

  # agents resolve
  while IFS= read -r a; do
    [[ "$a" == AGENT* ]] || continue
    name="${a#AGENT }"
    if [[ ! -r "$PLUGIN_ROOT/agents/$name.md" ]]; then
      fail "$rel — graph names agent:$name but agents/$name.md does not exist (R7)"
      r7_hits=$((r7_hits + 1))
    fi
  done <<< "$scan"

  # R7.b — six-functions coverage + slop gate, governed skills only
  if [[ $is_governed -eq 1 && -r "$SIX_MAP" ]]; then
    graph_agents="$(printf '%s\n' "$scan" | awk '/^AGENT /{print $2}')"
    gate_specs="$(printf '%s\n' "$scan" | awk '/^GATESPEC /{sub(/^GATESPEC /,""); print}')"
    while IFS= read -r mline; do
      [[ "$mline" =~ ^[[:space:]]*# ]] && continue
      [[ "$mline" =~ ^skills: ]] && continue
      [[ -z "${mline// }" ]] && continue
      func="${mline%%:*}"
      agents_csv="${mline#*:}"
      covered=0
      IFS=',' read -r -a fagents <<< "$agents_csv"
      for raw_fa in "${fagents[@]}"; do
        fa="${raw_fa#"${raw_fa%%[![:space:]]*}"}"; fa="${fa%"${fa##*[![:space:]]}"}"
        [[ -z "$fa" ]] && continue
        grep -qx -- "$fa" <<< "$graph_agents" && { covered=1; break; }
        grep -q -- "$fa" <<< "$gate_specs" && { covered=1; break; }
      done
      if [[ $covered -eq 0 ]]; then
        fail "$rel — graph does not cover six-functions \"$func\" (${agents_csv# }) (R7.b)"
        r7_hits=$((r7_hits + 1))
      fi
    done < "$SIX_MAP"

    if ! grep -qi -- "slop" <<< "$gate_specs"; then
      fail "$rel — artifact-producing graph has no slop gate node (R7.b)"
      r7_hits=$((r7_hits + 1))
    fi
  fi

  # R7.c — executor conformance
  wf="$(dirname "$f")/workflow.js"
  if [[ -r "$wf" ]]; then
    wrel="$(rel_plugin "$wf")"
    if ! grep -q "export const meta" "$wf"; then
      fail "$wrel — executor missing export const meta (R7.c)"
      r7_hits=$((r7_hits + 1))
    fi
    while IFS= read -r a; do
      [[ "$a" == AGENT* ]] || continue
      name="${a#AGENT }"
      if ! grep -qF -- "$name" "$wf"; then
        fail "$wrel — executor roster missing graph agent \"$name\" (R7.c)"
        r7_hits=$((r7_hits + 1))
      fi
    done <<< "$scan"
  fi

  # R7.d — refutation nodes. A node id beginning `refute` marks a refutation; the
  # skill must then (a) cite the adversary_model setting in its prose path and
  # (b) route every refutation in its executor through one refute() helper that
  # alone touches REFUTE_SCHEMA and ADVERSARY_MODEL (c), and call it (d); and
  # (e) pass the setting to the executor as `adversaryModel` — without it the
  # executor silently runs as `agent` forever.
  refute_ids="$(printf '%s\n' "$scan" | awk '/^REFUTE /{print $2}' | tr '\n' ' ')"
  if [[ -n "$refute_ids" ]]; then
    refute_ids="${refute_ids% }"
    wf="$(dirname "$f")/workflow.js"
    wrel="$(rel_plugin "$wf")"

    if ! grep -qF -- '${user_config.adversary_model}' "$f"; then
      fail "$rel — refutation node(s) ($refute_ids) but SKILL.md never cites \`\${user_config.adversary_model}\` (R7.d.a)"
      r7_hits=$((r7_hits + 1))
    fi

    if ! grep -qF -- 'adversaryModel' "$f"; then
      fail "$rel — refutation node(s) ($refute_ids) but SKILL.md never passes \`adversaryModel\` to the executor (R7.d.e)"
      r7_hits=$((r7_hits + 1))
    fi

    if [[ ! -r "$wf" ]]; then
      fail "$rel — refutation node(s) ($refute_ids) but $wrel does not exist (R7.d.b)"
      r7_hits=$((r7_hits + 1))
    else
      rscan="$(refute_scan "$wf")"
      if ! grep -qE -- '^[[:space:]]*const[[:space:]]+ADVERSARY_MODEL[[:space:]]*=' "$wf"; then
        fail "$wrel — refutation node(s) but no \`const ADVERSARY_MODEL =\` definition (R7.d.b)"
        r7_hits=$((r7_hits + 1))
      fi
      if ! grep -q '^DEF ' <<< "$rscan"; then
        fail "$wrel — refutation node(s) but no \`async function refute(\` helper at column 0 (R7.d.b)"
        r7_hits=$((r7_hits + 1))
      else
        # (c) REFUTE_SCHEMA / ADVERSARY_MODEL live only in their const lines and in refute()
        while IFS= read -r stray; do
          [[ "$stray" == STRAY* ]] || continue
          stray="${stray#STRAY }"
          fail "$wrel:${stray%%:*} — REFUTE_SCHEMA/ADVERSARY_MODEL used outside refute(): $(printf '%s' "${stray#*:}" | sed 's/^[[:space:]]*//' | cut -c1-90) (R7.d.c)"
          r7_hits=$((r7_hits + 1))
        done <<< "$rscan"
        # (d) refute() is actually called
        calls="$(awk '/^CALLS /{print $2; exit}' <<< "$rscan")"
        if [[ "${calls:-0}" -eq 0 ]]; then
          fail "$wrel — refute() is defined but never called outside its definition (R7.d.d)"
          r7_hits=$((r7_hits + 1))
        fi
      fi
    fi
  fi
done
if [[ $r7_hits -eq 0 ]]; then
  info "$r7_graphs graph block(s) valid"
fi

# ── R8 — auto-contract stub ───────────────────────────────────────────────────

section "R8 · auto-contract stub — skills/**"

r8_hits=0
for f in "${SKILL_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  grep -q -- "--auto" "$f" || continue
  rel="$(rel_plugin "$f")"
  if ! grep -q "Auto-Mode Safety Contract" "$f" || ! grep -qF "memory/orchestration.md" "$f"; then
    fail "$rel — mentions --auto but does not reference the Auto-Mode Safety Contract in memory/orchestration.md (R8)"
    r8_hits=$((r8_hits + 1))
  fi
done
[[ $r8_hits -eq 0 ]] && info "all --auto skills reference the contract"

# ── R9 — pattern-entry structure ──────────────────────────────────────────────

section "R9 · pattern entries — patterns/**"

r9_hits=0
r9_entries=0
PATTERN_FILES=()
while IFS= read -r line; do PATTERN_FILES+=("$line"); done < <(find "$PLUGIN_ROOT/patterns" -type f -name '*.md' -not -name 'README.md' -not -name 'INDEX.md' -not -path '*/archive/*' 2>/dev/null | sort)

for f in "${PATTERN_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  r9_entries=$((r9_entries + 1))
  for req in "^Problem:" "^Standard:" "^Verified:" "^## Solution" "^## Why this shape" "^## Prevents"; do
    if ! grep -qE "$req" "$f"; then
      fail "$rel — pattern entry missing required section \"${req#^}\" (R9)"
      r9_hits=$((r9_hits + 1))
    fi
  done
done
if [[ $r9_entries -eq 0 ]]; then
  info "no pattern entries — R9 N/A"
elif [[ $r9_hits -eq 0 ]]; then
  info "$r9_entries pattern entr$( [[ $r9_entries -eq 1 ]] && echo y || echo ies ) valid"
fi

# ── R10 — memory citations name their tier ────────────────────────────────────
#
# A bare `memory/X.md` resolves only when the working directory is the plugin
# root, so it silently misses in every consuming project. Every citation must
# name its tier:
#   Core     the plugin's `memory/X.md`
#   Product  `.claude/memory/X.md`
#   User     `~/.claude/memory/X.md`
#
# Exempt: lines that also carry `.claude/memory/` are the deliberate fallback
# chains (".claude/memory/X; if not found, check memory/X"), which degrade
# gracefully across project layouts by design.

section "R10 · memory citations name their tier — agents/** + skills/**"

r10_hits=0
for f in "${AGENT_FILES[@]}" "${SKILL_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  while IFS= read -r hit; do
    [[ -n "$hit" ]] || continue
    fail "$rel:${hit%%:*} — bare \`memory/…\` citation does not name its tier (R10)"
    r10_hits=$((r10_hits + 1))
  done < <(grep -n '`memory/' "$f" 2>/dev/null | grep -v "plugin's \`memory/" | grep -v '\.claude/memory/')
done
[[ $r10_hits -eq 0 ]] && info "all memory citations name their tier"

# ── R11 — agent model & effort ────────────────────────────────────────────────
#
# The doctrine table in memory/orchestration.md § Model and effort is the single
# source of truth for which agent runs on which model at which effort, and every
# agent's frontmatter must match it. A row's Agents cell is a comma-separated
# list of agent names, or exactly `every other agent` for the one default row.
# A row whose Model cell is the `adversary_model` setting rather than a model
# name (Refutation) assigns no agent. Effort `—` means the effort: key must be
# absent (Haiku takes no effort); every other model needs an effort level. A
# table that cannot be found or parsed is a FAIL, never a skip — otherwise
# deleting the table would disable the check.
#
# Verdict agents (pm cd de) are the PM → CD → DE guard chain: the last judgment
# before a ship, so they run on opus or fable at high effort or above. That
# floor is independent of the table, so editing the table cannot lower it.
#
# Prose never pins a model: the model lives in frontmatter, or in the
# adversary_model setting. Scanned: agent bodies (frontmatter excluded, it is the
# source), every SKILL.md, every workflow.js. Pins are `claude-<model>-<n>` IDs,
# `[OPUS]`-style markers, `model: <name>` (an agent-call option or prose
# instruction, any case, not the snake_case setting name `adversary_model: …`),
# and in workflow.js `<…>MODEL = '<name>'`.

section "R11 · agent model & effort — agents/*.md vs the doctrine table"

R11_MODELS="haiku sonnet opus fable"
R11_EFFORTS="low medium high xhigh max"
R11_VERDICT_AGENTS="pm cd de"
R11_TABLE_FILE="$PLUGIN_ROOT/memory/orchestration.md"
R11_TABLE_REL="memory/orchestration.md § Model and effort"

in_list() { [[ -n "$1" ]] || return 1; case " $2 " in *" $1 "*) return 0 ;; esac; return 1; }

# Value of a top-level frontmatter key (inline comment + quotes stripped).
# Exit 0 when the key is present (even if empty), 1 when absent.
frontmatter_get() {
  awk -v k="$2" '
    BEGIN { in_fm = 0; found = 0 }
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm && /^---[[:space:]]*$/ { exit }
    in_fm && index($0, k ":") == 1 {
      v = substr($0, length(k) + 2)
      sub(/[[:space:]]+#.*$/, "", v)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", v)
      gsub(/^["'\'']|["'\'']$/, "", v)
      print v
      found = 1
      exit
    }
    END { exit (found ? 0 : 1) }
  ' "$1"
}

# Line number of the frontmatter's closing `---`; prints nothing when the file
# has no frontmatter or it is never closed.
frontmatter_end() {
  awk '
    NR == 1 && /^---[[:space:]]*$/ { in_fm = 1; next }
    in_fm && /^---[[:space:]]*$/ { print NR; exit }
  ' "$1"
}

# Parse the § Model and effort table. Emits:
#   MAP<TAB>agent<TAB>model<TAB>effort|none<TAB>kind    one per named agent
#   DEFAULT<TAB>model<TAB>effort|none<TAB>kind          the `every other agent` row
#   ERR <message>                                       section, header or row malformed
model_table() {
  awk -v models="$R11_MODELS" -v efforts="$R11_EFFORTS" '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function unq(s)  { gsub(/`/, "", s); return trim(s) }
    function has(list, v) { return v != "" && index(" " list " ", " " v " ") > 0 }
    BEGIN { st = 0; sec = 0; hdr_ok = 0; hdr_err = 0; ndef = 0; nrows = 0 }
    st == 0 { if ($0 ~ /^### Model and effort[ \t]*$/) { st = 1; sec = 1 } ; next }
    st == 9 { next }
    /^#+[ \t]/ || /^---[ \t]*$/ { st = 9; next }
    st == 1 {
      if ($0 !~ /^\|/) next
      n = split($0, c, "|")
      if (n < 6 || trim(c[2]) != "Kind of work" || trim(c[3]) != "Agents" || trim(c[4]) != "Model" || trim(c[5]) != "Effort" || trim(c[6]) != "Why") {
        print "ERR table header is not exactly `| Kind of work | Agents | Model | Effort | Why |`"
        hdr_err = 1; st = 9; next
      }
      hdr_ok = 1; st = 2; next
    }
    st == 2 {
      if ($0 ~ /^\|[ \t:|-]+$/) { st = 3; next }
      print "ERR the table header is not followed by a |---| separator row"; hdr_err = 1; st = 9; next
    }
    st == 3 {
      if ($0 !~ /^\|/) { st = 9; next }
      n = split($0, c, "|")
      kind = trim(c[2])
      if (n < 6) { print "ERR row \"" kind "\" has fewer than the 5 cells of the header"; next }
      model = unq(c[4])
      if (!has(models, model)) {
        if (index(c[4], "adversary_model") > 0) next
        print "ERR row \"" kind "\": Model cell \"" model "\" is neither a model (" models ") nor the adversary_model setting"
        next
      }
      effort = unq(c[5])
      if (effort == "—") eff = "none"
      else if (has(efforts, effort)) eff = effort
      else { print "ERR row \"" kind "\": Effort cell \"" effort "\" is not one of: " efforts ", or —"; next }
      if (model == "haiku" && eff != "none") { print "ERR row \"" kind "\": haiku takes no effort — its Effort cell must be —"; next }
      if (model != "haiku" && eff == "none") { print "ERR row \"" kind "\": " model " needs an effort level — only haiku takes none"; next }
      if (unq(c[3]) == "every other agent") { ndef++; print "DEFAULT\t" model "\t" eff "\t" kind; next }
      m = split(c[3], a, ",")
      for (i = 1; i <= m; i++) {
        nm = unq(a[i])
        if (nm !~ /^[a-z0-9][a-z0-9-]*$/) {
          print "ERR row \"" kind "\": Agents entry \"" nm "\" is not an agent name (comma-separated names, or exactly `every other agent`)"
          continue
        }
        if (nm in seen) { print "ERR agent \"" nm "\" is named in two rows (\"" seen[nm] "\" and \"" kind "\")"; continue }
        seen[nm] = kind; nrows++
        print "MAP\t" nm "\t" model "\t" eff "\t" kind
      }
    }
    END {
      if (!sec) { print "ERR no `### Model and effort` section found"; exit }
      if (hdr_err) exit
      if (!hdr_ok) { print "ERR the section has no table"; exit }
      if (ndef != 1) print "ERR the table needs exactly one `every other agent` row, found " ndef
      if (nrows == 0) print "ERR the table names no agent"
    }
  ' "$1"
}

# Prose model pins in one file, one `<line>:<match>` per hit. $2 is the line the
# frontmatter ends on (0 = scan the whole file); that range is blanked, not cut,
# so line numbers stay true. $3 = code also checks assignment pins (workflow.js).
model_pins() {
  local bt text
  bt="$(printf '\x60')"
  text="$(awk -v e="$2" 'NR <= e { print ""; next } { print }' "$1")"
  {
    printf '%s\n' "$text" | grep -noE 'claude-(opus|sonnet|haiku|fable)-[0-9][A-Za-z0-9._-]*|\[(HAIKU|SONNET|OPUS|FABLE)\]'
    printf '%s\n' "$text" | grep -noiE "(^|[^_])model:[[:space:]]*['\"$bt]?(haiku|sonnet|opus|fable)([^A-Za-z0-9]|\$)" \
      | sed -E 's/^([0-9]+:)[^A-Za-z]/\1/; s/[^A-Za-z]$//'
    if [[ "${3:-}" == code ]]; then
      printf '%s\n' "$text" | grep -noiE "model[[:space:]]*=[[:space:]]*['\"$bt](haiku|sonnet|opus|fable)['\"$bt]"
    fi
  } | sort -t: -k1,1n -s
}

r11_hits=0

# The table: parse once; on any problem say so and skip only the per-agent match.
R11_TABLE_OK=0
R11_MAP=""
R11_DEFAULT=""
if [[ ! -r "$R11_TABLE_FILE" ]]; then
  fail "memory/orchestration.md is missing — there is no doctrine table to reconcile agents against (R11)"
  r11_hits=$((r11_hits + 1))
else
  tscan="$(model_table "$R11_TABLE_FILE")"
  if printf '%s\n' "$tscan" | grep -q '^ERR '; then
    while IFS= read -r e; do
      [[ "$e" == ERR* ]] || continue
      fail "$R11_TABLE_REL — ${e#ERR } (R11)"
      r11_hits=$((r11_hits + 1))
    done <<< "$tscan"
  else
    R11_TABLE_OK=1
    R11_MAP="$(printf '%s\n' "$tscan" | awk -F'\t' '$1 == "MAP" { print $2 "\t" $3 "\t" $4 "\t" $5 }')"
    R11_DEFAULT="$(printf '%s\n' "$tscan" | awk -F'\t' '$1 == "DEFAULT" { print $2 "\t" $3 "\t" $4; exit }')"
    while IFS=$'\t' read -r tn _; do
      [[ -n "$tn" ]] || continue
      if [[ ! -r "$PLUGIN_ROOT/agents/$tn.md" ]]; then
        fail "$R11_TABLE_REL — names agent \"$tn\" but agents/$tn.md does not exist (R11)"
        r11_hits=$((r11_hits + 1))
      fi
    done <<< "$R11_MAP"
  fi
fi

for f in "${AGENT_FILES[@]}"; do
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  name="$(basename "$f" .md)"
  file_hits=0

  model="$(frontmatter_get "$f" model)" && has_model=1 || has_model=0
  effort="$(frontmatter_get "$f" effort)" && has_effort=1 || has_effort=0

  # The declaration itself is well-formed.
  if [[ $has_model -eq 0 ]]; then
    fail "$rel — frontmatter has no model: (R11)"; file_hits=$((file_hits + 1))
  elif ! in_list "$model" "$R11_MODELS"; then
    fail "$rel — model: \"$model\" is not one of: $R11_MODELS (R11)"; file_hits=$((file_hits + 1))
  elif [[ "$model" == "haiku" ]]; then
    if [[ $has_effort -eq 1 ]]; then
      fail "$rel — model: haiku takes no effort, but effort: \"$effort\" is declared (R11)"; file_hits=$((file_hits + 1))
    fi
  elif [[ $has_effort -eq 0 ]]; then
    fail "$rel — frontmatter has no effort: (one of: $R11_EFFORTS) (R11)"; file_hits=$((file_hits + 1))
  elif ! in_list "$effort" "$R11_EFFORTS"; then
    fail "$rel — effort: \"$effort\" is not one of: $R11_EFFORTS (R11)"; file_hits=$((file_hits + 1))
  fi

  # It matches the agent's row in the doctrine table (named row, else the default row).
  if [[ $file_hits -eq 0 && $R11_TABLE_OK -eq 1 ]]; then
    trow="$(printf '%s\n' "$R11_MAP" | awk -F'\t' -v n="$name" '$1 == n { print $2 "\t" $3 "\t" $4; exit }')"
    [[ -n "$trow" ]] || trow="$R11_DEFAULT"
    IFS=$'\t' read -r want_model want_effort want_kind <<< "$trow"
    if [[ "$model" != "$want_model" ]]; then
      fail "$rel — model: $model, but the doctrine table assigns $want_model (row \"$want_kind\") (R11)"; file_hits=$((file_hits + 1))
    fi
    if [[ "$want_effort" == "none" ]]; then
      if [[ $has_effort -eq 1 ]]; then
        fail "$rel — effort: \"$effort\" declared, but the doctrine table assigns none (row \"$want_kind\") (R11)"; file_hits=$((file_hits + 1))
      fi
    elif [[ "$effort" != "$want_effort" ]]; then
      fail "$rel — effort: ${effort:-none}, but the doctrine table assigns $want_effort (row \"$want_kind\") (R11)"; file_hits=$((file_hits + 1))
    fi
  fi

  # Verdict floor — checked once the declaration matches the table.
  if [[ $file_hits -eq 0 ]] && in_list "$name" "$R11_VERDICT_AGENTS"; then
    if ! in_list "$model" "opus fable" || ! in_list "$effort" "high xhigh max"; then
      fail "$rel — verdict agent must declare model opus|fable and effort high|xhigh|max, found model: $model effort: ${effort:-none} (R11)"
      file_hits=$((file_hits + 1))
    fi
  fi
  r11_hits=$((r11_hits + file_hits))
done

# Prose model pins — agent bodies, SKILL.md, workflow.js.
WORKFLOW_FILES=()
while IFS= read -r line; do WORKFLOW_FILES+=("$line"); done < <(find "$PLUGIN_ROOT/skills" -type f -name 'workflow.js' 2>/dev/null | sort)

for f in "${AGENT_FILES[@]}" "${SKILL_FILES[@]}" ${WORKFLOW_FILES[@]+"${WORKFLOW_FILES[@]}"}; do   # bash 3.2 + set -u: an empty array must not expand bare
  [[ -r "$f" ]] || continue
  rel="$(rel_plugin "$f")"
  fm_end=0; kind=""
  case "$f" in
    "$PLUGIN_ROOT"/agents/*) fm_end="$(frontmatter_end "$f")"; fm_end="${fm_end:-0}" ;;
    *workflow.js)            kind="code" ;;
  esac
  while IFS=: read -r lineno pin; do
    [[ -n "$lineno" ]] || continue
    fail "$rel:$lineno — prose model pin \"$pin\" — the model lives in the agent's frontmatter or the adversary_model setting (R11)"
    r11_hits=$((r11_hits + 1))
  done < <(model_pins "$f" "$fm_end" "$kind")
done
[[ $r11_hits -eq 0 ]] && info "${#AGENT_FILES[@]} agents match the doctrine table; no prose model pins"

# ── R12 — eval coverage ───────────────────────────────────────────────────────
#
# CLAUDE.md "Eval Coverage": no agent or skill ships without an eval. An agent is
# covered only by behavioral evals that name it: a `## <Name> — …` heading in an
# evals/*.eval.md (Name lowercased, spaces→hyphens, equals the agent name:
# `## Design Validator — Eval 8` → design-validator, `## DE — Eval 5` → de), or
# the file's single `Agent:` line naming exactly that agent, in a file that has
# at least one `## Eval` heading. Listing agents on an `Agents:` line does not
# count — a line can claim coverage no eval delivers. skills.eval.md names skills
# (luck is both), so it never covers an agent. Skills are covered by a
# `## <name>` heading in evals/skills.eval.md (the whole token — `## design` does
# not cover design-system-init).

section "R12 · eval coverage — agents/ + skills/ vs evals/"

r12_hits=0
SKILLS_EVAL="$SCRIPT_DIR/skills.eval.md"

# Agent names one eval file covers, one per line. Fenced blocks are ignored.
eval_file_agents() {
  awk '
    function norm(s) { s = tolower(s); gsub(/^[ \t]+|[ \t]+$/, "", s); gsub(/[ \t]+/, "-", s); return s }
    in_fence && /^[ \t]*```[ \t]*$/ { in_fence = 0; next }
    !in_fence && /^[ \t]*```/ { in_fence = 1; next }
    in_fence { next }
    /^## Eval/ { has_eval = 1 }
    /^## / { i = index($0, " —"); if (i > 4) print norm(substr($0, 4, i - 4)) }
    /^Agent:/ { n_agent++; a = $0; sub(/^Agent:[ \t]*/, "", a); gsub(/`/, "", a); gsub(/[ \t]+$/, "", a); single = a }
    END { if (has_eval && n_agent == 1 && single != "") print single }
  ' "$1"
}

covered_agents=""
for ef in "$SCRIPT_DIR"/*.eval.md; do
  [[ -r "$ef" && "$ef" != "$SKILLS_EVAL" ]] || continue
  covered_agents="$covered_agents
$(eval_file_agents "$ef")"
done

for f in "${AGENT_FILES[@]}"; do
  name="$(basename "$f" .md)"
  if ! grep -qxF -- "$name" <<< "$covered_agents"; then
    fail "agent $name has no eval coverage — needs a \`## <Name> — …\` heading in an evals/*.eval.md, or to be that file's singular \`Agent:\` (R12)"
    r12_hits=$((r12_hits + 1))
  fi
done

if [[ ! -r "$SKILLS_EVAL" ]]; then
  fail "$(rel_plugin "$SKILLS_EVAL") is missing — no skill has eval coverage (R12)"
  r12_hits=$((r12_hits + 1))
else
  for f in "${SKILL_FILES[@]}"; do
    name="$(basename "$(dirname "$f")")"
    if ! grep -qE "^## ${name}([[:space:]]|\$)" "$SKILLS_EVAL"; then
      fail "skill $name has no eval coverage — no \`## $name\` heading in evals/skills.eval.md (R12)"
      r12_hits=$((r12_hits + 1))
    fi
  done
fi
[[ $r12_hits -eq 0 ]] && info "${#AGENT_FILES[@]} agents and ${#SKILL_FILES[@]} skills have eval coverage"

# ── project-level checks (R3 + IBR) ───────────────────────────────────────────

if [[ -n "$PROJECT_ROOT" ]]; then
  manifest_md="$PROJECT_ROOT/.claude/memory/project-context.md"
  if [[ ! -r "$manifest_md" ]]; then
    section "project checks"
    fail "$PROJECT_ROOT — missing $manifest_md (cannot run R3 / IBR without manifest)"
  else
    manifest="$(awk '
      BEGIN { in_section = 0; in_yaml = 0 }
      /^##[[:space:]]+Engineering Context[[:space:]]*$/ { in_section = 1; next }
      in_section && /^##[[:space:]]+/ { exit }
      in_section && /^[[:space:]]*```yaml[[:space:]]*$/ { in_yaml = 1; next }
      in_section && in_yaml && /^[[:space:]]*```[[:space:]]*$/ { in_yaml = 0; next }
      in_section && in_yaml { print; next }
      in_section { print }
    ' "$manifest_md")"

    manifest_get() {
      printf '%s\n' "$manifest" | awk -v k="$1" '
        $1 == k":" { sub(/^[^:]+:[[:space:]]*/, ""); sub(/[[:space:]]*#.*$/, ""); sub(/[[:space:]]*$/, ""); gsub(/^["'\'']|["'\'']$/, ""); print; exit }
      '
    }

    STACK_VAL="$(manifest_get stack)"
    CODE_ROOT_VAL="$(manifest_get code_root)"
    SHARED_MODULE_VAL="$(manifest_get shared_module_name)"
    SHARING_MECH_VAL="$(manifest_get sharing_mechanism)"
    GEN_TOOL_VAL="$(manifest_get generation_tool)"

    [[ -z "$CODE_ROOT_VAL" ]] && CODE_ROOT_VAL="code/"
    [[ "$CODE_ROOT_VAL" == "." || "$CODE_ROOT_VAL" == "./" ]] && CODE_ROOT_VAL=""

    CANVAS_PATH="$PROJECT_ROOT/${CODE_ROOT_VAL%/}/canvas"
    SHARED_PATH="$PROJECT_ROOT/${CODE_ROOT_VAL%/}/shared"
    CANVAS_PATH="${CANVAS_PATH//\/\//\/}"
    SHARED_PATH="${SHARED_PATH//\/\//\/}"

    # ── R3 — no-fork / drift ───────────────────────────────────────────────
    section "R3 · no-fork / drift — canvas ↔ shared (project: $PROJECT_ROOT)"

    r3_hits=0
    if [[ -d "$CANVAS_PATH" && -d "$SHARED_PATH" ]]; then
      if [[ ${#HASH_CMD[@]} -eq 0 ]]; then
        warn "no sha256 utility found — content-duplication hash check skipped"
      else
        # bash 3.2: use a temp file as hash→path map
        HASH_MAP="$(mktemp)"
        trap 'rm -f "$HASH_MAP"' EXIT
        while IFS= read -r -d '' sf; do
          h="$(normalized_hash "$sf")"
          [[ -n "$h" ]] && printf '%s\t%s\n' "$h" "$sf" >> "$HASH_MAP"
        done < <(find "$SHARED_PATH" -type f \( -name '*.swift' -o -name '*.ts' -o -name '*.tsx' -o -name '*.kt' \) -print0)

        while IFS= read -r -d '' cf; do
          h="$(normalized_hash "$cf")"
          [[ -z "$h" ]] && continue
          match="$(awk -F'\t' -v k="$h" '$1==k{print $2; exit}' "$HASH_MAP")"
          if [[ -n "$match" ]]; then
            fail "duplicate content — canvas: $cf shared: $match (R3 fork)"
            r3_hits=$((r3_hits + 1))
          fi
        done < <(find "$CANVAS_PATH" -type f \( -name '*.swift' -o -name '*.ts' -o -name '*.tsx' -o -name '*.kt' \) -print0)
      fi

      if [[ "$SHARING_MECH_VAL" == "spm-local" ]]; then
        while IFS= read -r -d '' f; do
          while IFS=: read -r lineno text; do
            [[ -z "$lineno" ]] && continue
            if echo "$text" | grep -qE '(CTFontManagerRegisterFontsForURL|UIImage\(contentsOfFile:|NSImage\(contentsOfFile:|Data\(contentsOf:|String\(contentsOf:)'; then
              fail "${f#$PROJECT_ROOT/}:$lineno — #filePath used to resolve resources outside Bundle.module (R3)"
              r3_hits=$((r3_hits + 1))
            fi
          done < <(grep -n -F '#filePath' "$f" 2>/dev/null || true)
        done < <(find "$PROJECT_ROOT" -type f -name '*.swift' -not -path "*/\.*" -print0)
      fi

      [[ $r3_hits -eq 0 ]] && info "no canvas↔shared forks, no #filePath resource leaks"
    else
      info "canvas_path or shared_path not present — shape app-only or scaffold not yet present; R3 N/A"
    fi

    # ── IBR — included-by-reference ────────────────────────────────────────
    section "IBR · included-by-reference — invariant check"

    ibr_hits=0
    case "$SHARING_MECH_VAL" in
      spm-local)
        case "$GEN_TOOL_VAL" in
          xcodegen)
            YML_FILES=()
            while IFS= read -r line; do YML_FILES+=("$line"); done < <(find "$PROJECT_ROOT" -type f -name 'project.yml' -not -path "*/\.*" 2>/dev/null)
            if [[ ${#YML_FILES[@]} -eq 0 ]]; then
              fail "no project.yml found under $PROJECT_ROOT (generation_tool: xcodegen but no source)"
              ibr_hits=$((ibr_hits + 1))
            fi
            for yml in "${YML_FILES[@]}"; do
              rel="${yml#$PROJECT_ROOT/}"
              has_path=0; has_url=0
              grep -qE '^[[:space:]]+path:[[:space:]]*\.\.' "$yml" && has_path=1
              grep -qE '^[[:space:]]+url:[[:space:]]*' "$yml" && has_url=1
              if [[ $has_url -eq 1 && $has_path -eq 0 ]]; then
                fail "$rel — packages declared via registry URL, not path: (IBR)"
                ibr_hits=$((ibr_hits + 1))
              elif [[ $has_path -eq 0 ]]; then
                fail "$rel — no path-based ../shared package dependency (IBR)"
                ibr_hits=$((ibr_hits + 1))
              fi
            done
            ;;
          none|"")
            PBX_FILES=()
            while IFS= read -r line; do PBX_FILES+=("$line"); done < <(find "$PROJECT_ROOT" -type f -name '*.pbxproj' -not -path "*/\.*" 2>/dev/null)
            for pbx in "${PBX_FILES[@]}"; do
              rel="${pbx#$PROJECT_ROOT/}"
              if grep -q 'XCRemoteSwiftPackageReference' "$pbx" && ! grep -q 'XCLocalSwiftPackageReference' "$pbx"; then
                fail "$rel — uses XCRemoteSwiftPackageReference but no XCLocalSwiftPackageReference (IBR)"
                ibr_hits=$((ibr_hits + 1))
              elif ! grep -q 'XCLocalSwiftPackageReference' "$pbx"; then
                fail "$rel — no XCLocalSwiftPackageReference (manual path: ../shared must be wired) (IBR)"
                ibr_hits=$((ibr_hits + 1))
              fi
            done
            ;;
        esac
        ;;

      pnpm-workspace|npm-workspace|yarn-workspace)
        if ! command -v python3 >/dev/null 2>&1; then
          warn "python3 not found — workspace IBR check skipped"
        else
          py_out="$(PROJECT_ROOT="$PROJECT_ROOT" python3 -c '
import json, os, sys, glob
root = os.environ["PROJECT_ROOT"]
failed = 0
top = os.path.join(root, "package.json")
if not os.path.exists(top):
    for guess in ("code/package.json",):
        p = os.path.join(root, guess)
        if os.path.exists(p):
            top = p; break
if not os.path.exists(top):
    print(f"FAIL no root package.json found under {root}")
    sys.exit(1)
with open(top) as fh:
    pkg = json.load(fh)
workspaces = pkg.get("workspaces") or []
if isinstance(workspaces, dict):
    workspaces = workspaces.get("packages") or []
joined = " ".join(workspaces)
if "shared" not in joined:
    print(f"FAIL root package.json workspaces missing shared: {top}")
    failed = 1
for sub in ("app", "canvas"):
    if sub not in joined:
        print(f"WARN root package.json workspaces missing {sub}: {top}")
for member_glob in workspaces:
    for member in glob.glob(os.path.join(os.path.dirname(top), member_glob, "package.json")):
        if os.path.abspath(member) == os.path.abspath(top):
            continue
        with open(member) as fh:
            mp = json.load(fh)
        deps = {**(mp.get("dependencies") or {}), **(mp.get("devDependencies") or {})}
        for name, spec in deps.items():
            if name.endswith("shared") or "shared" in name:
                if not (spec == "*" or spec.startswith("workspace:")):
                    print(f"FAIL {member} depends on {name}@{spec} — not a workspace dep (IBR)")
                    failed = 1
sys.exit(failed)
')"
          if [[ -n "$py_out" ]]; then
            while IFS= read -r line; do
              if [[ "$line" == FAIL* ]]; then
                fail "${line#FAIL }"; ibr_hits=$((ibr_hits + 1))
              elif [[ "$line" == WARN* ]]; then
                warn "${line#WARN }"
              fi
            done <<< "$py_out"
          fi
        fi
        ;;

      gradle-project)
        info "gradle-project IBR check not yet validated; specialist not yet shipped"
        ;;

      "")
        info "sharing_mechanism not declared in manifest — IBR N/A"
        ;;

      *)
        warn "unknown sharing_mechanism: \"$SHARING_MECH_VAL\" — IBR check skipped"
        ;;
    esac

    [[ $ibr_hits -eq 0 && -n "$SHARING_MECH_VAL" && "$SHARING_MECH_VAL" != "gradle-project" ]] && info "included-by-reference invariant holds"
  fi
fi

# ── summary ───────────────────────────────────────────────────────────────────

section "summary"
printf "FAIL: %d   WARN: %d\n" "$FAIL_COUNT" "$WARN_COUNT"

[[ $FAIL_COUNT -gt 0 ]] && exit 1
exit 0
