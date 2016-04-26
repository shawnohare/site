readonly publish_repo="https://github.com/shawnohare/shawnohare.github.io"
readonly publish_dir="shawnohare.github.io"
readonly generator="shawnohare.com"
readonly public_dir="public"
readonly public_tmp="public_tmp"
readonly themes_dir="themes"
readonly themes_repo="https://github.com/shawnohare/hugo-morphism"
readonly theme="hugo-morphism"
readonly theme_path="${themes_dir}/${theme}"
readonly rev=$(git rev-parse HEAD)


init() {
  echo "Initializing."
  return 0
}

get_theme() {
  if [[ ! -d "${theme_path}" ]]; then
    git clone "${themes_repo}" "${theme_path}"
  else 
    # Update the theme.
    (cd "${theme_path}" && git pull)
  fi
  return 0
}

build_site() {
  hugo --destination="${public_dir}"
  if [ $? -eq 0 ]; then 
    return 0 
  else 
    echo "Error building site.  Exiting."
    cleanup
    exit 1 
  fi
}



publish() {
  if [[ ! -d "${public_dir}" ]]; then
    echo "No site to publish!"
    cleanup
    exit 1
  fi
  cd "${public_dir}"
  # Init or re-init a git repo in the public dir hugo just created.
  git init
  git remote add origin "${publish_repo}" # this will fail
  git add .
  git commit -m "Generated from ${generator} commit ${rev}"
  git push -f --set-upstream origin master
  return 0
}

cleanup() {
  echo "Cleaning up."
}

main() {
  init
  get_theme
  build_site 
  publish
  cleanup
  return 0
}

main


