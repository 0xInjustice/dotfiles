# ssh-port-forwarding — expose services using SSH

```sh
ssh -L LPORT:HOST:PORT user@server
```

**Remote (reverse):**

```sh
ssh -R RPORT:localhost:LPORT user@server
```

DESCRIPTION
Local forwarding maps a remote service to localhost.
Remote forwarding exposes a local service via an SSH server.

## FREE PUBLIC SSH TUNNELS

**localhost.run**

```sh
ssh -R 80:localhost:3000 ssh.localhost.run
```

**bore.pub**

```sh
bore local 3000 --to bore.pub
```

**serveo.net** Unstable. Often unavailable.
`sh
              ssh -R 80:localhost:3000 serveo.net
      `

**ngrok (free tier)**

```sh
ngrok http 3000
```

> [!NOTE]
> Public SSH tunnels are disposable.
> For reliability, use Cloudflare Tunnel or your own VPS with ssh -R.
