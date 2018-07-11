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
- RLPx: https://github.com/ethereum/devp2p/blob/master/rlpx.md
- https://en.wikibooks.org/wiki/The_World_of_Peer-to-Peer_(P2P)/Building_a_P2P_System#Building_a_P2P_System
- http://www.zeroconf.org/

## Dev usage

```elixir
# Add secret locally
myid = Meshington.Identity.new("first")
secret = Meshington.Secret.new("mysecret", "http://google.com", "user", "pass")
:ok = Meshington.Database.add(myid, secret)
Meshington.Database.list()

# Connect to "peer" (ourselves)
{:ok, client} = Meshington.Net.Client.connect("tcp://localhost:3511")

# Simulate that some other peer has secrets they want to sync with us
otherid = Meshington.Identity.new("other")
secret2 = Meshington.Secret.new("othersecret", "http://example.com", "user2", "pass2")
other_db = %Meshington.Database{secrets: Loom.AWORSet.new() |> Loom.AWORSet.add(otherid, secret2)}
Meshington.Net.Client.send_state(client, other_db)

# Show the result
# :sys.get_state(Meshington.Database)
Meshington.Database.list()
```

## TODO

- [ ] v0: Keep secrets state in memory
- [ ] v0: Communication protocol. Could start with elixir structs serialized with `:erlang.term_to_binary/1`.
- [ ] v0: Decide network topology (fully connected, line, bus...). Since only trusted peers will be connected the network will usually be small (10s of peers).
- [ ] v0: Implement identifier scheme for peers
- [ ] v1: Make sure secrets state is persisted
- [ ] v1: Security. Only establish/accept connections to trusted peers. This is obviously essential.
- [ ] v2: Node tracker / bootstrap server: A service that can act as a centralized directory of available nodes. I would really like to have something extremely simple for this. Important for usability, but low prio for now. How should this work? Needs to be optional, and be easily replaced with homegrown solutions.

---

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

