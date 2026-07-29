# Vanity URL

Akash Network [Vanity URL](https://gianarb.it/blog/go-mod-vanity-url) for go mods.
We use [vangen](https://github.com/leighmcculloch/vangen) for generating this repo.

## How to add a module

- Make sure [direnv](https://direnv.net) is installed. It will install `vangen` util into local cache
- Make changes to `vangen.json`
- `make vangen`
- Push your changes

## How to add a new node major version

When the `akash-network/node` repo introduces a new major version (e.g. `v3`, `v4`) on a new branch,
a corresponding entry must be added to `vangen.json`. **Do not modify existing entries.**

Add a new object to the `repositories` array:

```json
{
  "prefix": "node/vN",
  "type": "git",
  "main": true,
  "url": "https://github.com/akash-network/node",
  "source": {
    "home": "https://github.com/akash-network/node",
    "dir": "https://github.com/akash-network/node/tree/BRANCH{/dir}",
    "file": "https://github.com/akash-network/node/blob/BRANCH{/dir}/{file}#L{line}"
  },
  "website": {
    "url": "https://github.com/akash-network/node"
  }
}
```

Replace `N` with the major version number and `BRANCH` with the corresponding git branch name.

**Example:** v2 uses the `wasm` branch → prefix `node/v2`, branch `wasm`.

Then run:

```
make vangen
```

Verify that `node/vN/index.html` was generated and existing `node/` pages are unchanged, then push.
