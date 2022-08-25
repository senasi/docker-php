#!/bin/sh

# FULLY BORRWED FROM: https://github.com/nginxinc/docker-nginx
# https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/20-envsubst-on-templates.sh

set -e

auto_envsubst() {
  local template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR:-/etc/nginx/templates}"
  local suffix="${NGINX_ENVSUBST_TEMPLATE_SUFFIX:-.template}"
  local output_dir="${NGINX_ENVSUBST_OUTPUT_DIR:-/etc/nginx/conf.d}"

  local template defined_envs relative_path output_path subdir
  defined_envs=$(printf '${%s} ' $(env | cut -d= -f1))
  [ -d "$template_dir" ] || return 0
  if [ ! -w "$output_dir" ]; then
    echo "ERROR: $template_dir exists, but $output_dir is not writable"
    return 0
  fi
  find "$template_dir" -follow -type f -name "*$suffix" -print | while read -r template; do
    relative_path="${template#$template_dir/}"
    output_path="$output_dir/${relative_path%$suffix}"
    subdir=$(dirname "$relative_path")
    # create a subdirectory where the template file exists
    mkdir -p "$output_dir/$subdir"
    echo "Running envsubst on $template to $output_path"
    envsubst "$defined_envs" < "$template" > "$output_path"
  done
}

if [ "$1" = "nginx" ] || [ "$1" = "docker-nginx" ]; then
  auto_envsubst
fi