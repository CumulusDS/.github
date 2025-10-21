#!/usr/bin/env zsh

set -euf -o pipefail;

# Change console text color
colors() {
  export COLOR_NC='\e[0m'; # No Color
  export COLOR_BLACK='\e[0;30m';
  export COLOR_GRAY='\e[1;30m';
  export COLOR_RED='\e[0;31m';
  export COLOR_LIGHT_RED='\e[1;31m';
  export COLOR_GREEN='\e[0;32m';
  export COLOR_LIGHT_GREEN_BOLD='\e[1;32m';
  export COLOR_YELLOW='\e[0;33m';
  export COLOR_YELLOW_BOLD='\e[1;33m';
  export COLOR_BLUE='\e[0;34m';
  export COLOR_LIGHT_BLUE='\e[1;34m';
  export COLOR_PURPLE='\e[0;35m';
  export COLOR_PINK_BOLD='\e[1;35m';
  export COLOR_CYAN='\e[0;36m';
  export COLOR_CYAN_BOLD='\e[1;36m';
  export COLOR_LIGHT_GRAY='\e[0;37m';
  export COLOR_WHITE_BOLD='\e[1;37m';
  export COLOR_LIGHT_DEFAULT='\e[0;39m';
  export COLOR_DEFAULT='\e[1;39m';
};

# Usage: `log_error "this is an error"`
log_error() {
  declare -r msg="${1}";
  declare -r timestamp="$(date '+%Y-%m-%d %H:%M:%S')";
  declare -r file_date="$(date '+%Y-%m-%d_%H.%M.%S')";

  # shellcheck disable=SC2154
  script_name="$(echo "${ZSH_ARGZERO}" | sed -e "s/\.[^.]*$//" -e 's/^.*\///')"; # ZSH only
  # script_name="${0}"  # bash only # double-check this

  declare -r log_dir="${HOME}/Scripts/var/log/${script_name}";
  mkdir -p "${log_dir}";
  echo "${timestamp} ERROR: ${msg}" >> "${log_dir}/${file_date}.log";
};

# Usage:
# `[[ -f "required_file.txt" ]] || error "Required file not found"
# error_exit "this file must be present to continue"`
# use this when you want multiple lines or to do stuff in between
error() {
  log_error "${1}"; echo "Error: ${1}" >&2;
};

# Print error and exit with a failure
error_exit() {
  log_error "${1}";
  printf "${COLOR_RED}Error: %s${1}${COLOR_NC}\\n" 1>&2;
  exit "${2:-1}";
};

##
main() {
  # determine project package manager
  if [[ -e "./pnpm-lock.yaml" ]]; then
    echo "project is using pnpm";
    declare -r PM="pnpm";
  fi;
  if [[ -e "./package-lock.json" ]]; then
    echo "project is using npm";
    declare -r PM="npm";
  fi;
  if [[ -e "./yarn.lock" ]]; then
    echo "project is using yarn";
    declare -r PM="yarn";
  fi;

  # bail if none found
  if [[ -z "${PM}" ]]; then
    log_error "Unable to determine package manager!"
    error_exit "Are you running in a project directory?";
  fi;

  # list of packages
  declare -a packages=(
    "@cumulusds/eslint"
    "@cumulusds/lint-staged"
    "@cumulusds/prettier"
    "@cumulusds/tsconfig"
    "@cumulusds/tsdoc"
    "eslint"
    "husky"
    "is-ci"
    "lint-staged"
    "prettier"
  );

  # set install arguments based on detected package manager
  [[ "${PM}" == "npm" ]] && args="install --save-dev";
  [[ "${PM}" == "pnpm" ]] && args="add --save-dev";
  [[ "${PM}" == "yarn" ]] && args="install --dev";

  # install packages
  eval "${PM} ${args} ${packages[*]}";

  # initiate husky
  eval "${PM} husky init";
  git add ".husky";

  # update package.json "prepare" script
  jq '.scripts.prepare = "is-ci || husky"' package.json > tmp.json && mv "tmp.json" "package.json";

  # echo "lint-staged --config ./lint-staged.config.mjs" > ".husky/pre-commit";
  wget -vc -O "./.husky/pre-commit" \
    "https://raw.githubusercontent.com/CumulusDS/.github/refs/heads/master/.husky/pre-commit"
  wget -vc -O "./.husky/pre-push" \
    "https://raw.githubusercontent.com/CumulusDS/.github/refs/heads/master/.husky/pre-push"
  wget -vc -O "./.husky/pre-receive" \
    "https://raw.githubusercontent.com/CumulusDS/.github/refs/heads/master/.husky/pre-receive"
  wget -vc -O "./eslint.config.mjs" \
    "https://raw.githubusercontent.com/CumulusDS/.github/refs/heads/master/eslint.config.mjs"
  wget -vc -O "./lint-staged.config.mjs" \
    "https://raw.githubusercontent.com/CumulusDS/.github/refs/heads/master/lint-staged.config.mjs"

  git add \
    "./.husky/pre-commit" \
    "./.husky/pre-push" \
    "./.husky/pre-receive" \
    "./eslint.config.mjs" \
    "./lint-staged.config.mjs"
};

main "${@}"
