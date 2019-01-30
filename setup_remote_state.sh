#!/bin/bash
readonly ARGS="$@"
readonly RESTORE='\033[0m'
readonly RED='\033[00;31m'
readonly TERRAFORM_RC="$PWD/.terraformrc"
readonly TERRAFORM_PLUGIN_CACHE="$PWD/.terraform.d/plugin-cache"

setup_terraform_plugin_cache() {
  if [[ ! -d "${TERRAFORM_PLUGIN_CACHE}" ]]; then
    echo "Terraform Plugin Cache Dir doesn't exist - making it (${TERRAFORM_PLUGIN_CACHE}).."
    mkdir -p "${TERRAFORM_PLUGIN_CACHE}"
  fi

  if ! grep -q plugin_cache_dir "${TERRAFORM_RC}" 2>/dev/null; then
    echo "Adding missing plugin_cache_dir setting to ${TERRAFORM_RC}"
    echo "plugin_cache_dir = \"${TERRAFORM_PLUGIN_CACHE}\"" | tee "${TERRAFORM_RC}"
  fi

}
setup_terraform_remote() {
  ENV=$1
  PROJ=$2

  check_for_local_tfstate_files "${ENV}" "${PROJ}"
  cd "${ENV}"
  terraform init -backend=true -get=true -input=false -backend-config="${ENV}"/remote_state.tfvars
  cd -
}

check_for_local_tfstate_files() {
  ENV=$1
  PROJ=$2
  if [ $(find "${ENV}" -type f -name "*.tfstate" | wc -l) -ne 0 ]; then
    echo -en "${RED}"
    echo "  *** Found local .tfstate files in ${PROJ}/${ENV} ***"
    echo "It looks like you might have accidentally used terraform in ${PROJ}/${ENV} without"
    echo "running this script - so you have a local state file. Please go into ${PROJ}/${ENV}"
    echo "and sort out this state. Ideally destroy it if you can, or if it is in prod"
    echo "you may have to try and get this state synced with the remote copy."
    echo ""
    echo "When you have dealt with the problem - delete the .tfstate/.tfstate.backup"
    echo "and rerun this script."
    echo ""
    echo -en "Aborting script now.${RESTORE}\n"
    exit 1
  fi
}

enumerate_dirs() {
  PROJ=$1
  echo "Enumerating Dirs in ${PROJ}"
  for DIR in $(find . -type d -name "*" -exec basename {} \;); do
    if [ -f "${DIR}/.terraform/terraform.tfstate" ]; then
      echo -e "** ${DIR}\t\tAlready set-up\n"
    else
      echo -e "** ${DIR}\tNeeds set-up\n"
      setup_terraform_remote "${DIR}" "${PROJ}"
    fi
  done
}

loop_projects() {
  BASEDIR="$(pwd)"
  for PROJ in refinitiv_infra; do
    cd "${PROJ}"
    enumerate_dirs "${PROJ}"
    cd "${BASEDIR}"
  done

}

nuke_dot_terraform_dirs() {
  find . -name terraform.tfstate -path "*/*/.terraform/*" -type f -delete
}

parse_args() {
  if [ "${ARGS}" == "force" ]; then
    echo "Reconfiguring all environments' terraform remote config"

    nuke_dot_terraform_dirs
    loop_projects
  else
    loop_projects
  fi
}

setup_terraform_plugin_cache
parse_args
