# Signing Key

Public key for the APT repository signing key.

- Key ID (long): `E3D3789E05CC5D91`
- Fingerprint: `16B257DD7A7E4080605F5720E3D3789E05CC5D91`

The private key must never be committed. Use GitHub Actions secret `SORYOS_APT_GPG_PRIVATE`.

## Export the private key (for GitHub Actions secret)

To export the private key (required for the `SORYOS_APT_GPG_PRIVATE` GitHub Actions secret):

```bash
gpg --export-secret-keys --armor E3D3789E05CC5D91
```

Copy the entire output (from `-----BEGIN PGP PRIVATE KEY BLOCK-----` to `-----END PGP PRIVATE KEY BLOCK-----`) and paste it into the GitHub Actions secret `SORYOS_APT_GPG_PRIVATE`.

## How to add the secret on GitHub

1. Go to `https://github.com/SoryOS/soryos-apt/settings/secrets/actions`
2. Click **New repository secret**
3. Name: `SORYOS_APT_GPG_PRIVATE`
4. Value: paste the full output of the command above
5. Click **Add secret**

Also add these **Variables** (not Secrets):
- `SORYOS_APT_GPG_KEYID` = `E3D3789E05CC5D91`
- `SORYOS_APT_CODENAME` = `soryos-26.04`