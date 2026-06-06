### FUNNY PROGRAMS ###

function reverse { echo "${(j::)${(@Oa)${(s::):-$1}}}" }

function excuse {
  local lang="${1:-en}"
  local data="$HOME/.bofh-excuses/excuses.json"
  if [[ -f "$data" ]] && command -v jq &>/dev/null; then
    jq -r --arg lang "$lang" '.excuses[][$lang] // .excuses[].en' "$data" | shuf -n 1
  else
    echo "No excuses available. Blame DNS."
  fi
}
