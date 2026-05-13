# soryos-apt

Static APT repository for SoryOS, published on GitHub Pages.

## Layout

The published site contains:

- `dists/<codename>/main/binary-amd64/Packages.gz`
- `dists/<codename>/Release`, `InRelease`, `Release.gpg`
- `pool/main/*.deb`

## Publish (CLI)

1. Put your `.deb` files into `incoming/`.
2. Run:

```sh
./publish.sh --codename soryos-26.04 --component main --arch amd64 \
  --gpg-key <KEYID> \
  --incoming ./incoming \
  --out ./public
```

## GitHub Pages

This repo is intended to deploy `public/` to the `gh-pages` branch.
The workflow is in `.github/workflows/publish.yml`.
