# Content Generator For gopkg.microglot.org 

This repo contains the build and deploy for the <gopkg.microglot.org> subdomain.
The subdomain is set up to serve Go modules HTML meta tags that allow for
<gopkg.microglot.org> to be used as an import URL rather than directly using a
VCS URL.

This repo uses <https://github.com/leighmcculloch/vangen> to generate the HTML
content and publishes the results to CloudFlare pages.
