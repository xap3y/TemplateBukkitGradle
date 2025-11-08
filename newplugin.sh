#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------
# Defaults / Configuration (overridable via env or CLI)
# -------------------------------------------
TEMPLATE_DIR="${TEMPLATE_DIR:-/home/xap3y/Desktop/code/Bukkit/TemplateBukkitGradle}"
TEMPLATE_GIT_URL="${TEMPLATE_GIT_URL:-https://github.com/xap3y/TemplateBukkitGradle.git}"
TEMPLATE_GIT_REF="${TEMPLATE_GIT_REF:-main}"
DEST_PARENT_DIR_DEFAULT="${DEST_PARENT_DIR_DEFAULT:-/home/xap3y/Desktop/code/Bukkit}"

PLUGIN_NAME_ARG=""
DEST_PARENT_DIR_ARG=""
NON_INTERACTIVE=0
ASSUME_YES=0
DRY_RUN=0

# -------------------------------------------
# Color handling
# -------------------------------------------
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'
  C_BLUE=$'\033[34m'
  C_AQUA=$'\033[36m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_DIM=$'\033[2m'
else
  C_RESET=""; C_BLUE=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_DIM=""
fi

log()      { printf "%s%s%s\n" "${C_AQUA}" "$*" "${C_RESET}" >&2; }
warn()     { printf "%s%s%s\n" "${C_YELLOW}" "$*" "${C_RESET}" >&2; }
error()    { printf "%s%s%s\n" "${C_RED}" "$*" "${C_RESET}" >&2; }
success()  { printf "%s%s%s\n" "${C_GREEN}" "$*" "${C_RESET}" >&2; }
dim()      { printf "%s%s%s\n" "${C_DIM}" "$*" "${C_RESET}" >&2; }

# -------------------------------------------
# Usage
# -------------------------------------------
usage() {
  cat >&2 <<EOF
Usage: $0 [options]

Options:
  -n, --name <PluginName>        Plugin name (CamelCase)
  -d, --dest-parent <Directory>  Destination parent directory (default: current prompt or DEST_PARENT_DIR_DEFAULT via keyword 'default')
  -y, --yes                      Assume yes to all (skip confirmations)
      --non-interactive          Fail instead of prompting when data missing
      --dry-run                  Show what would happen; no filesystem changes
      --template-dir <dir>       Override TEMPLATE_DIR
      --template-git-url <url>   Override TEMPLATE_GIT_URL
      --template-git-ref <ref>   Override TEMPLATE_GIT_REF
  -h, --help                     Show this help

Environment overrides:
  TEMPLATE_DIR, TEMPLATE_GIT_URL, TEMPLATE_GIT_REF, DEST_PARENT_DIR_DEFAULT

Examples:
  $0 -n TestPlugin -d ~/dev/plugins
  NO_COLOR=1 $0 --name SamplePlugin

EOF
}

# -------------------------------------------
# Parse CLI
# -------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--name) PLUGIN_NAME_ARG="$2"; shift 2 ;;
    -d|--dest-parent) DEST_PARENT_DIR_ARG="$2"; shift 2 ;;
    --template-dir) TEMPLATE_DIR="$2"; shift 2 ;;
    --template-git-url) TEMPLATE_GIT_URL="$2"; shift 2 ;;
    --template-git-ref) TEMPLATE_GIT_REF="$2"; shift 2 ;;
    -y|--yes) ASSUME_YES=1; shift ;;
    --non-interactive) NON_INTERACTIVE=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) error "Unknown argument: $1"; usage; exit 1 ;;
  esac
done

# -------------------------------------------
# Gum detection
# -------------------------------------------
GUM_AVAILABLE=0
if command -v gum >/dev/null 2>&1; then
  GUM_AVAILABLE=1
fi

prompt_input() {
  local prompt="$1"
  local placeholder="$2"
  local value=""
  if [[ ${NON_INTERACTIVE} -eq 1 ]]; then
    return 1
  fi
  if [[ ${GUM_AVAILABLE} -eq 1 ]]; then
    value="$(gum input --placeholder "${placeholder}" --prompt "${prompt} ")"
  else
    if [[ -n "${placeholder}" ]]; then
      printf "%s%s%s [%s]: " "${C_AQUA}" "${prompt}" "${C_RESET}" "${placeholder}" >&2
    else
      printf "%s%s%s: " "${C_AQUA}" "${prompt}" "${C_RESET}" >&2
    fi
    IFS= read -r value || true
  fi
  printf "%s" "${value}"
}

confirm() {
  local msg="$1"
  if [[ ${ASSUME_YES} -eq 1 ]]; then return 0; fi
  if [[ ${NON_INTERACTIVE} -eq 1 ]]; then
    warn "Confirmation required but running non-interactively: $msg"
    return 1
  fi
  local ans=""
  if [[ ${GUM_AVAILABLE} -eq 1 ]]; then
    ans="$(gum confirm "${msg}" && echo yes || echo no)"
  else
    printf "%s%s? [y/N]: %s" "${C_YELLOW}" "${msg}" "${C_RESET}" >&2
    IFS= read -r ans || true
  fi
  [[ "${ans,,}" =~ ^(y|yes)$ ]]
}

# -------------------------------------------
# Collect plugin name
# -------------------------------------------
PLUGIN_NAME="${PLUGIN_NAME_ARG}"
if [[ -z "${PLUGIN_NAME}" ]]; then
  val="$(prompt_input 'Plugin name (CamelCase, no spaces)' 'TestPlugin' || true)"
  PLUGIN_NAME="${val//[[:space:]]/}"
fi
if [[ -z "${PLUGIN_NAME}" ]]; then
  error "Plugin name is required."
  exit 1
fi
if ! [[ "${PLUGIN_NAME}" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
  error "Plugin name must be CamelCase alphanumerics only (e.g., TestPlugin)."
  exit 1
fi

# -------------------------------------------
# Destination parent dir
# -------------------------------------------
if [[ -n "${DEST_PARENT_DIR_ARG}" ]]; then
  DEST_PARENT_INPUT="${DEST_PARENT_DIR_ARG}"
else
  DEST_PARENT_INPUT="$(prompt_input 'Destination parent directory (empty=.; type \"default\" for predefined)' '.' || true)"
fi

if [[ -z "${DEST_PARENT_INPUT}" ]]; then
  DEST_PARENT_INPUT="."
fi

if [[ "${DEST_PARENT_INPUT}" == "default" ]]; then
  DEST_PARENT_DIR="${DEST_PARENT_DIR_DEFAULT}"
elif [[ "${DEST_PARENT_INPUT}" == "." ]]; then
  DEST_PARENT_DIR="$(pwd)"
else
  DEST_PARENT_DIR="${DEST_PARENT_INPUT}"
fi

if [[ ! -d "${DEST_PARENT_DIR}" ]]; then
  if [[ ${DRY_RUN} -eq 1 ]]; then
    log "[dry-run] Would create directory: ${DEST_PARENT_DIR}"
  else
    mkdir -p "${DEST_PARENT_DIR}"
  fi
fi

# -------------------------------------------
# Template acquisition
# -------------------------------------------
CLEANUP_TMP=0
if [[ -n "${TEMPLATE_DIR}" && -d "${TEMPLATE_DIR}" ]]; then
  :
else
  if [[ -z "${TEMPLATE_GIT_URL}" ]]; then
    error "Template directory missing and TEMPLATE_GIT_URL not set."
    exit 1
  fi
  if ! command -v git >/dev/null 2>&1; then
    error "'git' required to clone TEMPLATE_GIT_URL."
    exit 1
  fi
  TMP_CLONE_DIR="$(mktemp -d)"
  CLEANUP_TMP=1
  log "Cloning template from ${TEMPLATE_GIT_URL} (ref=${TEMPLATE_GIT_REF:-default}) ..."
  if [[ ${DRY_RUN} -eq 1 ]]; then
    log "[dry-run] Would git clone here: ${TMP_CLONE_DIR}"
  else
    if [[ -n "${TEMPLATE_GIT_REF}" ]]; then
      git clone --depth=1 -b "${TEMPLATE_GIT_REF}" "${TEMPLATE_GIT_URL}" "${TMP_CLONE_DIR}"
    else
      git clone --depth=1 "${TEMPLATE_GIT_URL}" "${TMP_CLONE_DIR}"
    fi
    TEMPLATE_DIR="${TMP_CLONE_DIR}"
  fi
fi

if [[ ! -f "${TEMPLATE_DIR}/src/main/resources/plugin.yml" ]]; then
  error "plugin.yml not found at ${TEMPLATE_DIR}/src/main/resources/plugin.yml"
  [[ "${CLEANUP_TMP}" -eq 1 ]] && rm -rf "${TEMPLATE_DIR}" || true
  exit 1
fi

# -------------------------------------------
# Extract old metadata
# -------------------------------------------
PLUGIN_YML="${TEMPLATE_DIR}/src/main/resources/plugin.yml"

OLD_NAME="$(awk -F': *' '/^name:/{print $2; exit}' "${PLUGIN_YML}" | tr -d \"\')"
OLD_MAIN_FQN="$(awk -F': *' '/^main:/{print $2; exit}' "${PLUGIN_YML}" | tr -d \"\')"

if [[ -z "${OLD_NAME}" || -z "${OLD_MAIN_FQN}" ]]; then
  error "Could not extract name/main from plugin.yml"
  exit 1
fi

OLD_PACKAGE="${OLD_MAIN_FQN%.*}"
OLD_MAIN_CLASS="${OLD_MAIN_FQN##*.}"
OLD_PACKAGE_PATH="$(printf '%s' "${OLD_PACKAGE}" | tr '.' '/')"

BUILD_FILE=""
for f in build.gradle build.gradle.kts; do
  if [[ -f "${TEMPLATE_DIR}/${f}" ]]; then BUILD_FILE="${TEMPLATE_DIR}/${f}"; break; fi
done

SETTINGS_FILE=""
for f in settings.gradle settings.gradle.kts; do
  if [[ -f "${TEMPLATE_DIR}/${f}" ]]; then SETTINGS_FILE="${TEMPLATE_DIR}/${f}"; break; fi
done

PROPERTIES_GRADLE="${TEMPLATE_DIR}/gradle.properties"

OLD_BASE_COORD=""
if [[ -n "${BUILD_FILE}" ]]; then
  OLD_BASE_COORD="$(sed -n 's/.*baseCoordinates *= *["'\''"]\([^"'\''"]*\)["'\''].*/\1/p' "${BUILD_FILE}" | head -n1)"
fi

# Replace baseCoordinates = "TemplateBukkitGradle" in PROPERTIES_GRADLE
if [[ -n "${OLD_BASE_COORD}" && -f "${PROPERTIES_GRADLE}" ]]; then
  if grep -q "^baseCoordinates=" "${PROPERTIES_GRADLE}"; then
    OLD_BASE_COORD="$(sed -n 's/^baseCoordinates=\(.*\)/\1/p' "${PROPERTIES_GRADLE}" | head -n1)"
  fi
fi

OLD_ROOT_NAME=""
if [[ -n "${SETTINGS_FILE}" ]]; then
  OLD_ROOT_NAME="$(sed -n "s/.*rootProject.name *= *['\"]\([^'\"]*\)['\"].*/\1/p" "${SETTINGS_FILE}" | head -n1)"
fi

# -------------------------------------------
# New naming
# -------------------------------------------
NEW_NAME="${PLUGIN_NAME}"
NEW_SLUG="$(printf '%s' "${NEW_NAME}" | tr '[:upper:]' '[:lower:]')"
PKG_PREFIX="${OLD_PACKAGE%.*}"
NEW_PACKAGE="${PKG_PREFIX}.${NEW_SLUG}"
NEW_MAIN_CLASS="${NEW_NAME}"
NEW_MAIN_FQN="${NEW_PACKAGE}.${NEW_MAIN_CLASS}"

DEST_DIR="${DEST_PARENT_DIR}/${NEW_NAME}"

log "Scaffold summary:"
dim "  Template dir:      ${TEMPLATE_DIR}"
dim "  Destination dir:   ${DEST_DIR}"
dim "  Old plugin name:   ${OLD_NAME}"
dim "  Old main FQN:      ${OLD_MAIN_FQN}"
dim "  New plugin name:   ${NEW_NAME}"
dim "  New main FQN:      ${NEW_MAIN_FQN}"
dim "  Old base coord:    ${OLD_BASE_COORD:-<none>}"
dim "  Old root name:     ${OLD_ROOT_NAME:-<none>}"

if [[ -e "${DEST_DIR}" ]]; then
  error "Destination already exists: ${DEST_DIR}"
  exit 1
fi

if ! confirm "Proceed with creating plugin scaffold?"; then
  error "Aborted."
  exit 1
fi

# -------------------------------------------
# Copy template
# -------------------------------------------
if [[ ${DRY_RUN} -eq 1 ]]; then
  log "[dry-run] Would copy template into ${DEST_DIR}"
else
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude '.git' --exclude 'build' --exclude '.gradle' "${TEMPLATE_DIR}/" "${DEST_DIR}/"
  else
    mkdir -p "${DEST_DIR}"
    cp -a "${TEMPLATE_DIR}/." "${DEST_DIR}/"
    rm -rf "${DEST_DIR}/.git" "${DEST_DIR}/build" "${DEST_DIR}/.gradle" 2>/dev/null || true
  fi
fi

# -------------------------------------------
# Replace occurrences
# -------------------------------------------
if sed --version >/dev/null 2>&1; then IS_GNU=1; else IS_GNU=0; fi

replace_in_files() {
  local search="$1" replace="$2" dir="$3"
  [[ -z "${search}" || -z "${replace}" ]] && return 0
  local esc_search esc_replace
  esc_search="$(printf '%s' "${search}" | sed -e 's/[\/&]/\\&/g')"
  esc_replace="$(printf '%s' "${replace}" | sed -e 's/[\/&]/\\&/g')"
  if [[ ${DRY_RUN} -eq 1 ]]; then
    log "[dry-run] Would replace '${search}' -> '${replace}'"
    return 0
  fi
  while IFS= read -r -d '' f; do
    if [[ ${IS_GNU} -eq 1 ]]; then
      sed -i -e "s/${esc_search}/${esc_replace}/g" "$f"
    else
      sed -i '' -e "s/${esc_search}/${esc_replace}/g" "$f"
    fi
  done < <(find "${dir}" -type f \( \
      -name "*.java" -o -name "*.kt" -o -name "*.yml" -o -name "*.yaml" -o \
      -name "*.gradle" -o -name "*.gradle.kts" -o -name "settings.gradle" -o -name "settings.gradle.kts" -o \
      -name "gradle.properties" -o -name "*.md" \
    \) -print0)
}

# Specific replacements
replace_in_files "${OLD_PACKAGE}" "${NEW_PACKAGE}" "${DEST_DIR}"

if [[ -n "${OLD_BASE_COORD}" && "${OLD_BASE_COORD}" != "${NEW_NAME}" ]]; then
  replace_in_files "${OLD_BASE_COORD}" "${NEW_NAME}" "${DEST_DIR}"
fi
if [[ -n "${OLD_ROOT_NAME}" && "${OLD_ROOT_NAME}" != "${NEW_NAME}" ]]; then
  replace_in_files "${OLD_ROOT_NAME}" "${NEW_NAME}" "${DEST_DIR}"
fi

# gradle.properties baseCoordinates line
if [[ ${DRY_RUN} -eq 1 ]]; then
  if [[ -n "${OLD_BASE_COORD}" ]]; then
    log "[dry-run] Would set baseCoordinates=${NEW_NAME} in gradle.properties (if exists)."
  fi
else
  if [[ -n "${OLD_BASE_COORD}" && -f "${PROPERTIES_GRADLE}" ]]; then
    if grep -q "^baseCoordinates=" "${PROPERTIES_GRADLE}"; then
      if [[ ${is_gnu_sed} -eq 1 ]]; then
        sed -i -E "s|^baseCoordinates=.*$|baseCoordinates=${NEW_NAME}|" "${PROPERTIES_GRADLE}"
      else
        sed -i '' -E "s|^baseCoordinates=.*$|baseCoordinates=${NEW_NAME}|" "${PROPERTIES_GRADLE}"
      fi
    fi
  fi
fi

# -------------------------------------------
# Rename package directory & main class
# -------------------------------------------
JAVA_SRC_DIR="${DEST_DIR}/src/main/java"
OLD_PACKAGE_PATH="$(printf '%s' "${OLD_PACKAGE}" | tr '.' '/')"
NEW_PACKAGE_PATH="$(printf '%s' "${NEW_PACKAGE}" | tr '.' '/')"
OLD_PKG_DIR="${JAVA_SRC_DIR}/${OLD_PACKAGE_PATH}"
NEW_PKG_DIR="${JAVA_SRC_DIR}/${NEW_PACKAGE_PATH}"

if [[ ${DRY_RUN} -eq 1 ]]; then
  log "[dry-run] Would move ${OLD_PKG_DIR} -> ${NEW_PKG_DIR}"
else
  if [[ -d "${OLD_PKG_DIR}" ]]; then
    mkdir -p "$(dirname "${NEW_PKG_DIR}")"
    mv "${OLD_PKG_DIR}" "${NEW_PKG_DIR}"
  fi
fi

# Rename main classes
for ext in java kt; do
  if [[ -f "${NEW_PKG_DIR}/${OLD_MAIN_CLASS}.${ext}" && "${OLD_MAIN_CLASS}" != "${NEW_MAIN_CLASS}" ]]; then
    if [[ ${DRY_RUN} -eq 1 ]]; then
      log "[dry-run] Would rename ${OLD_MAIN_CLASS}.${ext} -> ${NEW_MAIN_CLASS}.${ext}"
    else
      mv "${NEW_PKG_DIR}/${OLD_MAIN_CLASS}.${ext}" "${NEW_PKG_DIR}/${NEW_MAIN_CLASS}.${ext}"
    fi
  fi
done

# -------------------------------------------
# Cleanup temporary clone
# -------------------------------------------
if [[ "${CLEANUP_TMP}" -eq 1 && ${DRY_RUN} -eq 0 ]]; then
  rm -rf "${TEMPLATE_DIR}" || true
fi

# -------------------------------------------
# Final
# -------------------------------------------
if [[ ${DRY_RUN} -eq 1 ]]; then
  success "[dry-run] Completed. No changes written."
else
  success "Done. New plugin scaffold: ${DEST_DIR}"
  cat >&2 <<EOF
Next steps:
  cd "${DEST_DIR}"
  ./gradlew clean build

EOF
fi