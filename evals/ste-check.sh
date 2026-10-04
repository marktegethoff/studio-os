#!/usr/bin/env bash
# evals/ste-check.sh
#
# Deterministic writing check — tiered ASD-STE100 by genre. The genres, their
# limits and rules are defined in the plugin's memory/writing.md; this script is
# the mechanical half of that doctrine. It reads finished HTML artifacts.
#
# Usage:
#   ste-check.sh [--vocab <design-vocabulary.md>] <file.html>...
#
# Exit codes:
#   0  no FAIL (WARNs allowed)
#   1  at least one FAIL
#   2  bad invocation (unknown option, no files, unreadable file)
#
# Output, one line per finding, then a summary:
#   FAIL|WARN  <file>:<line> — <genre> — <message> — "<first 10 words>…"
#   ste-check: N FAIL, M WARN in K file(s)
#
# Markup contract
#   <meta name="studio:genre" content="procedure|verdict|exploratory">   in <head>
#   data-genre="…"      per-element override, applies to its subtree
#   data-ste="off"      skip the subtree (quoted drafts, rule-break examples)
#   data-ste="copy"     shipping product copy: dictionary check only
#   class="orig"        a quoted draft: it MUST carry data-ste="off" (see WARN)
#   Skipped always: <script> <style> <svg> <pre> <code> <head>, and [bracketed
#   template placeholders]. An unknown data-genre or data-ste value is ignored.
#
# FAIL  (the list in the plugin's memory/writing.md § The checker; nothing else)
#   - missing or invalid studio:genre meta (a meta named studio:register is
#     not an alias; the meta belongs in <head>)
#   - a sentence over the limit in procedure (20 words) or verdict (25 words)
# WARN
#   - a sentence over 25 words in exploratory
#   - procedure, verdict: hedges and interjections (oops, sorry, unfortunately,
#     hopefully, perhaps, maybe, "it looks like", "seems to", "kind of", "sort of")
#   - procedure: -ing forms that are not a built-in non-verb noun/adjective and
#     not an approved dictionary word. Capitalised mid-sentence words, CamelCase,
#     identifiers and plurals ("settings") are technical names or nouns and pass.
#   - all text, including data-ste="copy": a dictionary word marked "not approved"
#     (and its regular -s/-es/-ed/-ing forms), with the approved alternative
#   - class "orig" without its own data-ste="off": the quoted draft is then
#     checked as prose. The class alone never skips a draft, so the markup stays
#     explicit. No WARN where the checker skips anyway (an off ancestor; <code>
#     <pre> <svg>).
#
# Text units and sentences
#   A unit is the text of one block element (p li td th dd dt div blockquote
#   figcaption section br, and the other block-level tags). A <span> starts its
#   own unit when it opens at the start of a unit or after a sentence end — the
#   cells of a title block, an item id, a side note — and stays inline in the
#   middle of a sentence. Units split into sentences on . ! ? followed by space
#   or end (e.g. i.e. vs. cf. never end one); the label separators · and • end
#   one too. A word is a token with a letter or digit. h1-h6 and th are labels:
#   no length or -ing check. Line numbers are those of the sentence's first word.
#
# Dictionary (--vocab): the `## Dictionary` table of the project's
# design-vocabulary.md, rows `| WORD (pos) | approved|not approved | alternative |`.
# A missing vocabulary file is not an error: a note goes to stderr and the
# dictionary check is skipped.
#
# Dependencies: bash 3.2+ and POSIX awk (mawk, gawk, BWK awk, busybox awk).
# No gawk-only features; no perl, no python.

set -uo pipefail

usage() {
  awk '/^# Usage:/,/^# Output,/ { if ($0 !~ /^# Output,/) print }' "$0" | sed 's/^# \{0,1\}//'
}

VOCAB=""
FILES=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --vocab)
      [[ $# -ge 2 ]] || { echo "ste-check: --vocab requires a path" >&2; exit 2; }
      VOCAB="$2"; shift 2 ;;
    --vocab=*)
      VOCAB="${1#--vocab=}"; shift ;;
    -h|--help)
      usage; exit 0 ;;
    --)
      shift
      while [[ $# -gt 0 ]]; do FILES+=("$1"); shift; done ;;
    -?*)
      echo "ste-check: unknown option: $1" >&2; usage >&2; exit 2 ;;
    *)
      FILES+=("$1"); shift ;;
  esac
done

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "ste-check: no files given" >&2; usage >&2; exit 2
fi
for f in "${FILES[@]}"; do
  [[ -f "$f" && -r "$f" ]] || { echo "ste-check: cannot read: $f" >&2; exit 2; }
done

# The awk program reads the files itself (BEGIN only), so an empty file is
# checked like any other and a file name with "=" is never taken for an
# assignment.
IFS= read -r -d '' AWK_PROG <<'AWK_EOF' || true
function trim(s) {
  sub(/^[ \t\r\n]+/, "", s); sub(/[ \t\r\n]+$/, "", s)
  return s
}
function count_nl(s,   t) { t = s; return gsub(/\n/, "\n", t) }
function nlines(k,   r) { r = ""; while (k-- > 0) r = r "\n"; return r }
function valid_genre(g) { return (g == "procedure" || g == "verdict" || g == "exploratory") }

function emit(level, ln, genre, msg, ex,   s) {
  s = level "  " fname ":" ln " — " (genre == "" ? "none" : genre) " — " msg
  if (ex != "") s = s " — \"" ex "…\""
  o[++no] = s; olin[no] = ln + 0
  if (level == "FAIL") nfail++; else nwarn++
}

# Findings leave in line order. The input is nearly sorted (an element can report
# before the sentence that holds it), so a stable insertion sort costs O(n).
function sort_out(   i, j, kl, ks) {
  for (i = 2; i <= no; i++) {
    kl = olin[i]; ks = o[i]; j = i - 1
    while (j >= 1 && olin[j] > kl) { olin[j + 1] = olin[j]; o[j + 1] = o[j]; j-- }
    olin[j + 1] = kl; o[j + 1] = ks
  }
}

# ── text normalisation ──────────────────────────────────────────────────────

function decode(s) {
  if (index(s, "&") > 0) {
    gsub(/&(rsquo|lsquo|apos|#8217|#8216|#39|#x27);/, "'", s)
    gsub(/&(middot|bull|#183|#8226|#xb7|#xB7|#x2022);/, " . ", s)
    gsub(/&[#A-Za-z0-9]+;/, " ", s)
  }
  gsub(/“|”/, "\"", s)
  gsub(/‘|’/, "'", s)
  # · and • separate the items of a kit label line ("Files · what the task
  # writes"): each item is its own sentence. Dashes, arrows and the like are
  # not words and just drop out.
  gsub(/·|•/, " . ", s)
  gsub(/—|–|→|←|×|…/, " ", s)
  return s
}

# Remove [placeholders] (innermost first), keeping the newlines they held.
function strip_ph(s,   m, pre, post, nl) {
  while (index(s, "[") > 0 && match(s, /\[[^][]*\]/)) {
    m = substr(s, RSTART, RLENGTH)
    pre = substr(s, 1, RSTART - 1)
    post = substr(s, RSTART + RLENGTH)
    nl = count_nl(m)
    s = pre " " nlines(nl) post
  }
  return s
}

# ── sentence checks ─────────────────────────────────────────────────────────

# Is the word a dictionary "not approved" entry, or a regular form of one?
# Returns the entry key, or "".
function na_find(w,   l, c, c2) {
  if (w in ap) return ""
  if (w in na) return w
  l = length(w)
  if (l < 5) return ""
  if (w ~ /ies$/) { c = substr(w, 1, l - 3) "y"; if ((c in na) && !(c in ap)) return c }
  if (w ~ /s$/)   { c = substr(w, 1, l - 1); if ((c in na) && !(c in ap)) return c }
  if (w ~ /es$/)  { c = substr(w, 1, l - 2); if ((c in na) && !(c in ap)) return c }
  if (w ~ /ed$/) {
    c = substr(w, 1, l - 2); if ((c in na) && !(c in ap)) return c
    c = substr(w, 1, l - 1); if ((c in na) && !(c in ap)) return c
    c2 = substr(w, 1, l - 3)
    if (substr(w, l - 3, 1) == substr(w, l - 2, 1) && (c2 in na) && !(c2 in ap)) return c2
  }
  if (w ~ /ing$/) {
    c = substr(w, 1, l - 3); if ((c in na) && !(c in ap)) return c
    c = substr(w, 1, l - 3) "e"; if ((c in na) && !(c in ap)) return c
    c2 = substr(w, 1, l - 4)
    if (substr(w, l - 4, 1) == substr(w, l - 3, 1) && (c2 in na) && !(c2 in ap)) return c2
  }
  return ""
}

# Is the raw token a flaggable -ing form?
function ing_flag(raw, first,   t, w) {
  t = raw
  sub(/^[^A-Za-z0-9]+/, "", t); sub(/[^A-Za-z0-9]+$/, "", t)
  sub(/'s$/, "", t)
  if (t == "") return 0
  if (t ~ /[0-9_.\/:@#]/) return 0
  if (index(t, "-") > 0) sub(/^.*-/, "", t)
  if (length(t) < 5) return 0
  if (substr(t, 2) ~ /[A-Z]/) return 0
  if (!first && t ~ /^[A-Z]/) return 0
  w = tolower(t)
  if (w !~ /ing$/) return 0
  if ((w in ing_ok) || (w in ap)) return 0
  return 1
}

function sentence(   i, w, k, ex, g, p2, p3, alt, msg) {
  if (nw == 0) return
  g = ugenre
  ex = ""
  for (i = 1; i <= nw && i <= 10; i++) ex = ex (i > 1 ? " " : "") tw[i]
  for (i = 1; i <= nw; i++) {
    w = tolower(tw[i])
    sub(/^[^a-z0-9]+/, "", w); sub(/[^a-z0-9]+$/, "", w); sub(/'s$/, "", w)
    nt[i] = w
  }
  nt[nw + 1] = ""; nt[nw + 2] = ""

  if (umode != 2) {
    if (!ulabel) {
      if (g == "procedure" && nw > 20)
        emit("FAIL", sline, g, "sentence has " nw " words (limit 20)", ex)
      else if (g == "verdict" && nw > 25)
        emit("FAIL", sline, g, "sentence has " nw " words (limit 25)", ex)
      else if (g == "exploratory" && nw > 25)
        emit("WARN", sline, g, "sentence has " nw " words (guide 25)", ex)
    }
    if (g == "procedure" || g == "verdict") {
      for (i = 1; i <= nw; i++) {
        if (nt[i] in hs) { emit("WARN", sline, g, "hedge \"" nt[i] "\"", ex); continue }
        p2 = nt[i] " " nt[i + 1]
        if (p2 in hp) { emit("WARN", sline, g, "hedge \"" p2 "\"", ex); continue }
        p3 = p2 " " nt[i + 2]
        if (p3 in hp) emit("WARN", sline, g, "hedge \"" p3 "\"", ex)
      }
    }
    if (g == "procedure" && !ulabel) {
      for (i = 1; i <= nw; i++)
        if (ing_flag(tw[i], i == 1)) emit("WARN", sline, g, "-ing form \"" nt[i] "\" — use the imperative or a noun", ex)
    }
  }

  if (have_dict) {
    for (i = 1; i <= nw; i++) {
      w = nt[i]
      if (w == "") continue
      k = na_find(w)
      if (k == "") {
        p2 = w " " nt[i + 1]
        p3 = p2 " " nt[i + 2]
        if ((p2 in na) && !(p2 in ap)) { k = p2; w = p2 }
        else if ((p3 in na) && !(p3 in ap)) { k = p3; w = p3 }
      }
      if (k != "") {
        alt = na[k]
        msg = "dictionary: \"" w "\"" (k != w ? " (form of \"" k "\")" : "") " is not approved"
        if (alt != "") msg = msg " — use " alt
        emit("WARN", sline, g, msg, ex)
      }
    }
  }
  nw = 0
}

# Split one unit into sentences and check each.
function unit(b,   rest, pre, tok, nl, core) {
  b = strip_ph(decode(b))
  rest = b; nl = 0; nw = 0; pend = 0
  while (match(rest, /[^ \t\r\n]+/)) {
    pre = substr(rest, 1, RSTART - 1)
    tok = substr(rest, RSTART, RLENGTH)
    rest = substr(rest, RSTART + RLENGTH)
    if (pre != "") nl += count_nl(pre)
    if (tok ~ /[A-Za-z0-9]/) {
      if (pend) { if (tok ~ /^[A-Z0-9"'(]/) sentence(); pend = 0 }
      if (nw == 0) sline = uline + nl
      tw[++nw] = tok
    }
    if (tok ~ /[.!?][]"')]*$/) {
      core = tolower(tok)
      sub(/[]"')]+$/, "", core); sub(/^[^a-z0-9]+/, "", core)
      if (core in abbr_never) continue
      if (core in abbr_cond) { pend = 1; continue }
      sentence()
    }
  }
  sentence()
}

# ── unit buffer ─────────────────────────────────────────────────────────────

function add_text(txt, tline) {
  if (cskip == 1 || txt == "") return
  if (ubuf == "") {
    uline = tline; uend = tline
    ugenre = cgenre; umode = cskip; ulabel = clabel
  } else if (tline > uend) {
    ubuf = ubuf nlines(tline - uend); uend = tline
  }
  ubuf = ubuf txt
  uend += count_nl(txt)
}

function flush(   b) {
  if (ubuf == "") return
  b = ubuf; ubuf = ""
  if (b ~ /[A-Za-z0-9]/) unit(b)
}

# A span opens its own unit at a unit start or after a sentence end.
function at_boundary() {
  if (ubuf ~ /^[ \t\r\n]*$/) return 1
  return (ubuf ~ /[.!?][]"')]*[ \t\r\n]*$/)
}

# ── element stack ───────────────────────────────────────────────────────────

function recalc(   j) {
  cgenre = docgenre; cskip = 0; clabel = 0; chead = 0
  for (j = 1; j <= sp; j++) {
    if (sgen[j] != "") cgenre = sgen[j]
    if (sskip[j] == 1) cskip = 1
    else if (sskip[j] == 2 && cskip == 0) cskip = 2
    if (slabel[j]) clabel = 1
    if (shead[j]) chead = 1
  }
}

# Pop elements down to and including level j. Flushes when any is a boundary.
function pop_to(j,   k, brkany, wasskip) {
  brkany = 0
  for (k = sp; k >= j; k--) if (sbrk[k]) brkany = 1
  if (brkany) flush()
  wasskip = (cskip == 1)
  sp = j - 1
  recalc()
  if (!brkany && wasskip && cskip != 1) add_text(" ", tl)
}

function autoclose(nm,   t) {
  while (sp > 0) {
    t = sn[sp]
    if ((nm == "li" && t == "li") || (nm == "p" && t == "p") ||
        ((nm == "dt" || nm == "dd") && (t == "dt" || t == "dd")) ||
        ((nm == "td" || nm == "th") && (t == "td" || t == "th")) ||
        (nm == "tr" && (t == "td" || t == "th" || t == "tr")) ||
        (nm == "option" && t == "option")) pop_to(sp)
    else break
  }
}

# ── tag parsing ─────────────────────────────────────────────────────────────

# Index of the first > outside quotes, or 0.
function tag_end(s,   i, n, c, q) {
  n = length(s); q = ""
  for (i = 1; i <= n; i++) {
    c = substr(s, i, 1)
    if (q != "") { if (c == q) q = "" }
    else if (c == "\"" || c == "'") q = c
    else if (c == ">") return i
  }
  return 0
}

function is_ws(c) { return (c == " " || c == "\t" || c == "\n" || c == "\r") }

# Is `want` one of the whitespace-separated tokens of a class attribute?
function has_class(cl, want) {
  gsub(/[ \t\r\n]+/, " ", cl)
  return (index(" " cl " ", " " want " ") > 0)
}

# Attributes of one tag -> a_name a_content a_genre a_ste a_class (h_ = present).
function parse_attrs(s,   i, n, c, st, key, val, q) {
  a_name = ""; a_content = ""; a_genre = ""; a_ste = ""; a_class = ""
  h_genre = 0; h_ste = 0
  n = length(s); i = 1
  while (i <= n) {
    c = substr(s, i, 1)
    if (is_ws(c) || c == "/") { i++; continue }
    st = i
    while (i <= n) {
      c = substr(s, i, 1)
      if (is_ws(c) || c == "=" || c == "/") break
      i++
    }
    key = tolower(substr(s, st, i - st))
    while (i <= n && is_ws(substr(s, i, 1))) i++
    val = ""
    if (substr(s, i, 1) == "=") {
      i++
      while (i <= n && is_ws(substr(s, i, 1))) i++
      c = substr(s, i, 1)
      if (c == "\"" || c == "'") {
        q = c; i++; st = i
        while (i <= n && substr(s, i, 1) != q) i++
        val = substr(s, st, i - st); i++
      } else {
        st = i
        while (i <= n && !is_ws(substr(s, i, 1))) i++
        val = substr(s, st, i - st)
        if (i > n) sub(/\/$/, "", val)
      }
    }
    if (key == "name") a_name = val
    else if (key == "content") a_content = val
    else if (key == "class") a_class = val
    else if (key == "data-genre") { a_genre = tolower(trim(val)); h_genre = 1 }
    else if (key == "data-ste") { a_ste = tolower(trim(val)); h_ste = 1 }
  }
}

function open_tag(nm, attrs, tline,   selfc, blk, brk, g, prevskip, isroot, jj) {
  parse_attrs(attrs)
  tl = tline
  selfc = (attrs ~ /\/[ \t\r\n]*$/)

  if (nm == "head" && head_line == 0) head_line = tline
  if (nm == "body") {
    seen_body = 1
    for (jj = sp; jj >= 1; jj--) if (sn[jj] == "head") { pop_to(jj); break }
  }
  # The meta belongs in <head>; a page that omits the <head> tag (legal HTML)
  # keeps it valid by putting the meta before <body>.
  if (nm == "meta" && (chead || !seen_body) && !meta_found && tolower(trim(a_name)) == "studio:genre") {
    meta_found = 1
    g = tolower(trim(a_content))
    if (valid_genre(g)) docgenre = g
    else emit("FAIL", tline, "", "invalid studio:genre \"" trim(a_content) "\" (expected procedure, verdict or exploratory)", "")
    recalc()
  }

  autoclose(nm)
  blk = (nm in isblock)
  if (nm == "span") blk = at_boundary()
  brk = blk || h_ste || (h_genre && valid_genre(a_genre))
  if (brk) flush()

  if ((nm in isvoid) || selfc) return

  isroot = (nm == "script" || nm == "style" || nm == "svg" || nm == "pre" || nm == "code" || nm == "head")
  if (cskip != 1 && !isroot && a_ste != "off" && has_class(a_class, "orig"))
    emit("WARN", tline, cgenre, "quoted draft (class \"orig\") lacks data-ste=\"off\" — add it", "")

  prevskip = cskip
  if (isroot && !brk && prevskip != 1) add_text(" ", tline)

  sp++
  sn[sp] = nm
  sgen[sp] = (h_genre && valid_genre(a_genre)) ? a_genre : ""
  sskip[sp] = isroot ? 1 : 0
  if (a_ste == "off") sskip[sp] = 1
  else if (a_ste == "copy" && sskip[sp] == 0) sskip[sp] = 2
  slabel[sp] = (nm ~ /^h[1-6]$/ || nm == "th")
  shead[sp] = (nm == "head")
  sbrk[sp] = brk
  recalc()
  if (nm == "script" || nm == "style") rawel = nm
}

function close_tag(nm, tline,   j) {
  tl = tline
  for (j = sp; j >= 1; j--) if (sn[j] == nm) break
  if (j >= 1) pop_to(j)
  if (rawel == nm) rawel = ""
}

# ── one file ────────────────────────────────────────────────────────────────

function process(doc,   parts, n, i, tok, base, e, tagpart, txt, tline, nm, attrs, closing, k, p) {
  # A regex separator, not "<": one-true-awk (macOS awk) also splits a one-character
  # separator at every newline, which would lose the line numbers.
  n = split(doc, parts, /[<]/)
  line = 1
  sp = 0; ubuf = ""; docgenre = ""; meta_found = 0; head_line = 0; seen_body = 0
  rawel = ""; incomment = 0; no = 0
  recalc()
  add_text(parts[1], 1)
  line += count_nl(parts[1])

  for (i = 2; i <= n; i++) {
    tok = parts[i]
    base = line

    if (incomment) {
      k = index(tok, "-->")
      if (k > 0) { incomment = 0; add_text(substr(tok, k + 3), base + count_nl(substr(tok, 1, k + 2))) }
      line = base + count_nl(tok)
      continue
    }
    if (rawel != "") {
      if (tolower(substr(tok, 1, length(rawel) + 1)) != "/" rawel) { line = base + count_nl(tok); continue }
    }
    if (substr(tok, 1, 3) == "!--") {
      k = index(substr(tok, 4), "-->")
      if (k > 0) add_text(substr(tok, k + 6), base + count_nl(substr(tok, 1, k + 5)))
      else incomment = 1
      line = base + count_nl(tok)
      continue
    }
    if (tok !~ /^[\/!?A-Za-z]/) {
      add_text("<" tok, base)
      line = base + count_nl(tok)
      continue
    }
    if (tok ~ /^[!?]/) {
      k = index(tok, ">")
      if (k > 0) add_text(substr(tok, k + 1), base + count_nl(substr(tok, 1, k)))
      line = base + count_nl(tok)
      continue
    }

    e = tag_end(tok)
    while (e == 0 && i < n) { i++; tok = tok "<" parts[i]; e = tag_end(tok) }
    if (e == 0) { line = base + count_nl(tok); continue }
    tagpart = substr(tok, 1, e - 1)
    txt = substr(tok, e + 1)
    tline = base + count_nl(tagpart)
    if (!match(tagpart, /^\/?[A-Za-z][A-Za-z0-9:_-]*/)) {
      add_text("<" tok, base)
      line = base + count_nl(tok)
      continue
    }
    nm = tolower(substr(tagpart, 1, RLENGTH))
    attrs = substr(tagpart, RLENGTH + 1)
    closing = (substr(nm, 1, 1) == "/")
    if (closing) { nm = substr(nm, 2); close_tag(nm, tline) }
    else open_tag(nm, attrs, tline)
    add_text(txt, tline)
    line = base + count_nl(tok)
  }
  flush()
}

function finish_file(   i) {
  if (!meta_found)
    emit("FAIL", head_line ? head_line : 1, "", "missing studio:genre meta (expected <meta name=\"studio:genre\" content=\"procedure|verdict|exploratory\"> in <head>)", "")
  sort_out()
  for (i = 1; i <= no; i++) print o[i]
}

BEGIN {
  nfail = 0; nwarn = 0

  bn = split("p li td th dd dt div blockquote figcaption section br tr ul ol dl table thead tbody tfoot header footer main nav aside article figure form fieldset caption summary details address hr h1 h2 h3 h4 h5 h6 body html head pre button label option legend", tmp, " ")
  for (bi = 1; bi <= bn; bi++) isblock[tmp[bi]] = 1
  bn = split("meta br img hr input link source col wbr area base embed param track", tmp, " ")
  for (bi = 1; bi <= bn; bi++) isvoid[tmp[bi]] = 1

  bn = split("oops sorry unfortunately hopefully perhaps maybe", tmp, " ")
  for (bi = 1; bi <= bn; bi++) hs[tmp[bi]] = 1
  hp["it looks like"] = 1; hp["seems to"] = 1; hp["kind of"] = 1; hp["sort of"] = 1

  bn = split("e.g. i.e. vs. cf.", tmp, " ")
  for (bi = 1; bi <= bn; bi++) abbr_never[tmp[bi]] = 1
  bn = split("etc. approx. fig.", tmp, " ")
  for (bi = 1; bi <= bn; bi++) abbr_cond[tmp[bi]] = 1

  bn = split("thing nothing something anything everything string spring ceiling meaning heading padding spacing setting timing easing wording warning onboarding rendering routing ranking rating pairing drawing building loading landing morning evening during bring sting swing sling fling cling wring sibling pudding lettering lighting lining binding branding framing styling theming naming sizing scaling spelling meeting training feeling offering painting shading tooling wiring mapping coding encoding clothing housing backing funding greeting hearing ending beginning opening engineering marketing shopping listing posting messaging pricing billing existing missing remaining pending ongoing incoming outgoing underlying", tmp, " ")
  for (bi = 1; bi <= bn; bi++) ing_ok[tmp[bi]] = 1

  have_dict = 0
  vf = ENVIRON["STE_VOCAB"]
  if (vf != "") {
    indict = 0; infence = 0
    while ((getline vl < vf) > 0) {
      sub(/\r$/, "", vl)
      if (vl ~ /^[ \t]*(```|~~~)/) { infence = !infence; continue }
      if (infence) continue
      # A # or ## heading opens or closes the section; ### and deeper stay inside it.
      if (vl ~ /^##?([ \t]|$)/) { indict = (vl ~ /^##[ \t]+Dictionary[ \t]*$/); continue }
      if (!indict || vl !~ /^[ \t]*\|/) continue
      if (split(vl, dc, "|") < 4) continue
      dw = trim(dc[2]); ds = tolower(trim(dc[3])); da = trim(dc[4])
      gsub(/[`*]/, "", dw); gsub(/`/, "", da)
      sub(/[ \t]*\([^)]*\)[ \t]*$/, "", dw)
      dk = tolower(dw)
      if (dk == "") continue
      if (ds == "approved") { ap[dk] = 1; have_dict = 1 }
      else if (ds == "not approved") { na[dk] = da; have_dict = 1 }
    }
    close(vf)
  }

  nfiles = 0
  for (ai = 1; ai < ARGC; ai++) {
    fname = ARGV[ai]
    fdoc = ""
    while ((getline fl < fname) > 0) { sub(/\r$/, "", fl); fdoc = fdoc fl "\n" }
    close(fname)
    process(fdoc)
    finish_file()
    nfiles++
  }
  printf "ste-check: %d FAIL, %d WARN in %d file(s)\n", nfail, nwarn, nfiles
  exit (nfail > 0 ? 1 : 0)
}
AWK_EOF

if [[ -n "$VOCAB" && ! -r "$VOCAB" ]]; then
  echo "ste-check: vocabulary not found: $VOCAB — dictionary check skipped" >&2
fi

STE_VOCAB="$VOCAB" awk "$AWK_PROG" "${FILES[@]}"
exit $?
