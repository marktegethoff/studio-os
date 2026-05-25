#!/usr/bin/env bash
# Studio OS — session-end deposit reminder.
# Fires on SessionEnd. Nudges the user to deposit the session's learnings via
# /studio-close so the studio compounds instead of forgetting. Pure reminder —
# it never writes anything; /studio-close does the (confirmed) deposits.
set -euo pipefail
printf '%s' '{"systemMessage":"Studio OS — session ending. Run /studio-close to deposit this session'"'"'s learnings (preferences · ledger · eval deltas · migrations) before they are lost."}'
