#!/usr/bin/env bash
# Studio OS — auto-mode guard.
#
# PreToolUse hook on the Bash tool. Mechanically enforces items 2–4 of the
# Auto-Mode Safety Contract (the plugin's memory/orchestration.md): while HEAD is
# on an auto/ branch, push, tag creation or deletion, release, PR creation or
# merge, and leaving for the primary branch are blocked — exit 2, reason on
# stderr, which Claude Code returns to the model.
#
# Fails open. Any internal problem — no jq, unparseable input, no git, not a
# repository — exits 0 silently: a hook that breaks ordinary work costs more
# than the floor it adds. A floor, not the contract. It reads command text, so a
# wrapped or indirect invocation can slip past it, and it sees only Bash; the
# prose contract still binds every --auto run.
#
# Matching is by act, not by mention: an act counts where a command word can
# start (line start, after ; & | ( { a quote or $( , optionally behind env
# assignments or sudo/time/exec…), so `git commit -m "no git push here"` and
# `git add release.sh` pass.

[[ -t 0 ]] && exit 0
input="$(cat 2>/dev/null)" || exit 0
[[ -n "$input" ]] || exit 0

# Cheap pre-filter on the raw payload — most Bash calls never reach jq or git.
case "$input" in
  *git*|*"gh "*|*release.sh*) ;;
  *) exit 0 ;;
esac

cmd=""; cwd=""
if command -v jq >/dev/null 2>&1 && printf '%s' "$input" | jq -e . >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)"
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
  [[ -n "$cmd" ]] || exit 0
else
  # No jq: take the first "command" / "cwd" string with sed; failing that, match
  # the raw payload. JSON escapes are decoded with printf %b (\n becomes a newline).
  json_str() { printf '%s' "$input" | sed -nE 's/.*"'"$1"'"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -n 1; }
  cmd="$(json_str command)"
  cwd="$(json_str cwd)"
  if [[ -n "$cmd" ]]; then cmd="$(printf '%b' "$cmd")"; else cmd="$input"; fi
fi

NL=$'\n'
SQ="'"
DQ='"'
SEP='[;&|)<>]'   # ends a command segment (a newline does too)

# A command word starts here: line start, a separator, quote or subshell opener,
# optionally behind env assignments or a wrapper word.
BOUND="(^|[;&|(\`$DQ$SQ{$NL]|[\$][(])[[:space:]]*"
WRAP='(([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]*|sudo|time|nohup|exec|env|command|then|else|do|!)[[:space:]]+)*'
HEAD="$BOUND$WRAP"
# git global options that may sit between `git` and the subcommand.
GITOPT='(([[:space:]]+(-C|-c|--git-dir|--work-tree|--namespace)([[:space:]]+|=)[^[:space:]]+)|([[:space:]]+--?[A-Za-z][A-Za-z-]*))*'
GIT="${HEAD}git${GITOPT}[[:space:]]+"
GH="${HEAD}gh(([[:space:]]+(-R|--repo)([[:space:]]+|=)[^[:space:]]+))*[[:space:]]+"
RELEASE_SH="${HEAD}"'((bash|sh|zsh|source|\.)[[:space:]]+(-[A-Za-z-]+[[:space:]]+)*)?[^[:space:];&|'"$DQ$SQ"'()]*release\.sh([^A-Za-z0-9_.-]|$)'

REST=""; MATCH=""; AFTER=""
# next_match <ere>: first match in $REST → $MATCH, text after it → $AFTER (and $REST).
next_match() {
  [[ "$REST" =~ $1 ]] || return 1
  MATCH="${BASH_REMATCH[0]}"
  AFTER="${REST#*"$MATCH"}"
  REST="$AFTER"
}

# The match ended on a whole word, not partway through a longer one.
whole_word() { [[ -z "$AFTER" || "$AFTER" == [[:space:]]* || "$AFTER" == $SEP* ]]; }

# tag_mutates <text after `git tag`, up to the end of its segment>
# Creation or deletion: a mutating flag, or a name argument with no listing flag.
tag_mutates() {
  local toks=() tok listing=0 arg=0
  IFS=$' \t' read -r -a toks <<< "$1"
  [[ ${#toks[@]} -gt 0 ]] || return 1
  for tok in "${toks[@]}"; do
    case "$tok" in
      --annotate|--sign|--delete|--force|--edit|--message|--message=*|--local-user|--local-user=*|--file|--file=*) return 0 ;;
      -l|--list|--list=*|-n|-n[0-9]*|-v|--verify|--contains|--no-contains|--points-at|--merged|--no-merged) listing=1 ;;
      --*) ;;
      -*) if [[ "$tok" =~ ^-[A-Za-z]+$ && "$tok" =~ [asdfmuFe] ]]; then return 0; fi ;;
      *) arg=1 ;;
    esac
  done
  [[ $arg -eq 1 && $listing -eq 0 ]]
}

ACT=""
# Reads command text only; no process is spawned until an act is found.
detect() {
  local re verb sub seg
  re="${GIT}"'push([^A-Za-z0-9_-]|$)'
  if [[ "$cmd" =~ $re ]]; then ACT="git push"; return; fi

  REST="$cmd"
  while next_match "${GIT}tag"; do
    whole_word || continue
    seg="${AFTER%%$SEP*}"; seg="${seg%%"$NL"*}"
    if tag_mutates "$seg"; then ACT="git tag"; return; fi
  done

  if [[ "$cmd" =~ $RELEASE_SH ]]; then ACT="release.sh"; return; fi

  for sub in "pr create" "pr merge" "release"; do
    re="${GH}${sub// /[[:space:]]+}"'([^A-Za-z0-9_-]|$)'
    if [[ "$cmd" =~ $re ]]; then ACT="gh $sub"; return; fi
  done

  # Leaving for the primary branch. `git checkout main -- <path>` restores a
  # file and stays put, so it passes.
  for verb in checkout switch; do
    REST="$cmd"
    while next_match "${GIT}${verb}([[:space:]]+-[^[:space:]]+)*[[:space:]]+(main|master)"; do
      whole_word || continue
      [[ "$AFTER" =~ ^[[:space:]]+--([[:space:]]|$) ]] && continue
      ACT="git $verb ${MATCH##*[[:space:]]}"; return
    done
  done
}
detect 2>/dev/null
[[ -n "$ACT" ]] || exit 0

[[ -n "$cwd" ]] || cwd="${CLAUDE_PROJECT_DIR:-$PWD}"
branch="$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)" || exit 0
case "$branch" in
  auto/*) ;;
  *) exit 0 ;;
esac

printf 'Studio OS auto-guard: "%s" is a human-only act while on %s (Auto-Mode Safety Contract — the plugin'"'"'s memory/orchestration.md). Stop and list it in the run'"'"'s final summary for the human to run.\n' "$ACT" "$branch" >&2
exit 2
