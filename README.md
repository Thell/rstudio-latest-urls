# rstudio-latest-urls
Daily Updated RStudio Build URLs.

A json containing the effective urls for RStudio products denoted by a path taken from
the `latest-build-urls.txt` file such that the path portion of

`https://rstudio.org/download/latest/preview/desktop/bionic/rstudio-latest-amd64.deb`

is

`preview.desktop.bionic.rstudio`

Usage:
```
  url=https://github.com/thell/rstudio-latest-urls/raw/master/latest.json
  url=$(jq -r '.preview.desktop.bionic.rstudio' <(curl -s -L ${url}))
  curl -s -o rstudio.deb "${url}"
```

Why do this instead of just using the 'latest' url? To proxy and cache the release build url and file.

It is an alternate to an single url on-demand solution such as

```
path=/rstudio.org/download/latest/preview/desktop/bionic/rstudio-latest-amd64.deb
url=http://en50lf18lv6fhg4.m.pipedream.net
url=$(jq -r '.latest' <(curl -s -L ${url}${path}))
curl -s -o rstudio.deb "${url}"
```
