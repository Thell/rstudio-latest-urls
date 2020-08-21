#!/bin/env bash

: <<\#*************************************************************************

Generates a json file of effective urls from `./latest-build-urls.txt`

#*************************************************************************

readarray -t build_urls < latest-build-urls.txt
declare -a effective_urls
declare -a url_paths_json

for i in ${!build_urls[*]}; do
  url=${build_urls[$i]}
  url=$(curl -s -I -w '%{url_effective}\n' -L ${url} -o /dev/null)
  effective_urls[$i]="${url}"

  url_path=${build_urls[$i]#*latest}
  url_path="${url_path%-latest*}/url"

  if [[ $i -eq $(( ${#build_urls[*]} - 1 )) ]]; then
    url_paths_json[$i]="\"${url_path}\""
  else
    url_paths_json[$i]="\"${url_path}\","
  fi
done
url_paths_json=('[' ${url_paths_json[@]} ']')

jq_cmd=$(cat << \EOL
reduce .[] as $url_paths
      ( {};
        ($url_paths | split("/") ) as $segments
        | $segments[1:-1] as $path
        | setpath($path; getpath($path) + $segments[-1])
      )
EOL
)
latest_json=$(jq "${jq_cmd}" <(echo ${url_paths_json[*]}))

url_index=0
for line in $(jq "${jq_cmd}" <(echo ${url_paths_json[*]})); do
  if [[ "${line}" =~ "url" ]]; then
    echo ${line/url/${effective_urls[$(( url_index++ ))]}}
  else
    echo "${line}"
  fi
done | jq '.' > latest.json
