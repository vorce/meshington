**This project is still in the idea phase. It has no functionality yet :)**

# Meshington

Meshington is a self-hosted, distributed password manager that
supports offline mode.

## Features

- Local web UI
- Support for multiple peers, editing and managing entries simultaneously
- Live updates with multiple peers
- Offline mode, make changes while not connected to peers. Results
will be eventually consistent with no need for manual conflict resolution.

## Sketchpad

Use flow:

1. Clone repo (or download binary? or use a docker image?)
2. Start `meshington` locally
3. Go to localhost:4000
4. Start adding entries (url, user, pwd, category/labels)
5. Add "peer" (another meshington instance that should be allowed)

## Resources

- Login: https://itnext.io/user-authentication-with-guardian-for-phoenix-1-3-web-apps-e2064cac0ec1 
- Inspiration: http://archagon.net/blog/2018/03/24/data-laced-with-history/
- UUID: https://github.com/zyro/elixir-uuid
- Inspiration: https://docs.syncthing.net/dev/device-ids.html#device-ids
- CRDTs: https://github.com/asonge/loom , https://github.com/SyncFree/antidote_crdt , https://github.com/lasp-lang/types

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
