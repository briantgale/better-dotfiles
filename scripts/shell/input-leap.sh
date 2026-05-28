#!/usr/bin/env bash
# input-leap-resign.sh
# Re-signs Input Leap after macOS updates and resets TCC permissions.
# Usage:
#   ./input-leap-resign.sh          # defaults to client mode
#   ./input-leap-resign.sh client
#   ./input-leap-resign.sh server

set -euo pipefail

MODE="${1:-client}"
APP_PATH="/Applications/InputLeap.app"
BUNDLE_ID="input-leap"

# ── Validate mode ────────────────────────────────────────────────────────────
if [[ "$MODE" != "client" && "$MODE" != "server" ]]; then
  echo "Usage: $0 [client|server]"
  exit 1
fi

echo "==> Input Leap post-update fix — mode: $MODE"
echo ""

# ── Check app exists ─────────────────────────────────────────────────────────
if [[ ! -d "$APP_PATH" ]]; then
  echo "ERROR: $APP_PATH not found. Is Input Leap installed?"
  exit 1
fi

# ── Kill running instances ───────────────────────────────────────────────────
echo "--- Stopping Input Leap..."
pkill -x "input-leapc" 2>/dev/null && echo "    Stopped input-leapc" || echo "    input-leapc was not running"
pkill -x "input-leaps" 2>/dev/null && echo "    Stopped input-leaps" || echo "    input-leaps was not running"
pkill -f "InputLeap"   2>/dev/null && echo "    Stopped InputLeap GUI" || echo "    InputLeap GUI was not running"
sleep 1

# ── Remove quarantine ────────────────────────────────────────────────────────
echo ""
echo "--- Removing quarantine attributes..."
xattr -dr com.apple.quarantine "$APP_PATH" 2>/dev/null && echo "    Cleared." || echo "    None found."

# ── Re-sign ──────────────────────────────────────────────────────────────────
echo ""
echo "--- Re-signing $APP_PATH with ad-hoc signature..."
codesign --force --deep --sign - "$APP_PATH"
echo "    Done."

# ── Verify signature ─────────────────────────────────────────────────────────
echo ""
echo "--- Verifying signature..."
if codesign -v "$APP_PATH" 2>&1; then
  echo "    Signature looks good."
else
  echo "    WARNING: Signature verification returned errors (may be non-fatal for ad-hoc)."
fi

# ── Reset SSL certificates ───────────────────────────────────────────────────
echo ""
echo "--- Resetting SSL certificates..."
SSL_DIR="$HOME/Library/Application Support/InputLeap/SSL"
if [[ -d "$SSL_DIR" ]]; then
  rm -rf "$SSL_DIR"
  echo "    Deleted: $SSL_DIR"
else
  echo "    SSL directory not found, nothing to delete."
fi

# ── Reset TCC permissions ────────────────────────────────────────────────────
echo ""
echo "--- Resetting TCC permissions for bundle: $BUNDLE_ID..."

# These may fail silently on some macOS versions; we continue regardless
tccutil reset Accessibility "$BUNDLE_ID" 2>/dev/null \
  && echo "    Reset: Accessibility" \
  || echo "    WARNING: Could not reset Accessibility via tccutil (may need manual removal)"

if [[ "$MODE" == "client" ]]; then
  tccutil reset InputMonitoring "$BUNDLE_ID" 2>/dev/null \
    && echo "    Reset: InputMonitoring" \
    || echo "    WARNING: Could not reset InputMonitoring via tccutil (may need manual removal)"
fi

# ── Manual steps reminder ────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  MANUAL STEPS REQUIRED"
echo "  Open System Settings → Privacy & Security for each item below"
echo "  Remove InputLeap from the list, then re-add / re-enable it."
echo "════════════════════════════════════════════════════════════════"
echo ""

if [[ "$MODE" == "client" ]]; then
  echo "  CLIENT machine — re-enable these:"
  echo ""
  echo "  1. Accessibility"
  echo "     System Settings → Privacy & Security → Accessibility"
  echo "     Remove InputLeap, re-add it, toggle ON"
  echo ""
  echo "  2. Input Monitoring"
  echo "     System Settings → Privacy & Security → Input Monitoring"
  echo "     Remove InputLeap, re-add it, toggle ON"
  echo ""
  echo "  (The client needs both to capture and redirect keyboard/mouse input)"
else
  echo "  SERVER machine — re-enable these:"
  echo ""
  echo "  1. Accessibility"
  echo "     System Settings → Privacy & Security → Accessibility"
  echo "     Remove InputLeap, re-add it, toggle ON"
  echo ""
  echo "  (The server only needs Accessibility to inject input events)"
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "  AFTER granting permissions:"
echo "  1. Start Input Leap on the SERVER first"
echo "  2. Start Input Leap on the CLIENT"
echo "  3. Accept the server fingerprint prompt on the client"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "==> Done."
