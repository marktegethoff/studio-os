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
#   R8   auto-contract stub            — skills/**                      (FAIL)
#        any skill mentioning --auto must reference the Auto-Mode
#        Safety Contract in memory/orchestration.md (no inline forks).
#   R9   pattern-entry structure       — patterns/**                    (FAIL)
#        every entry carries Problem/Standard/Verified + Solution/
#        Why this shape/Prevents sections (per patterns/README.md).
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
