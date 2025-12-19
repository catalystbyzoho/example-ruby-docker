# Ruby API + UI (Sinatra)

Small Ruby app with:

- **`/`**: a simple UI that lists all APIs available in the app
- **3 JSON APIs**:
  - `GET /api/ping`
  - `GET /api/time`
  - `POST /api/echo`

## Run locally

Requirements: Ruby **3.3+**

```bash
bundle install
bundle exec ruby app.rb
```

Then open:

- UI: `http://localhost:9000/`

## APIs

### `GET /api/ping`

```bash
curl -s http://localhost:9000/api/ping
```

### `GET /api/time`

```bash
curl -s http://localhost:9000/api/time
```

### `POST /api/echo`

```bash
curl -s -X POST http://localhost:9000/api/echo \
  -H 'Content-Type: application/json' \
  -d '{"hello":"world"}'
```

## Docker

Build:

```bash
docker build --platform=linux/amd64 -t ruby-rest-api .
```

Run:

```bash
docker run --rm -p 9000:9000 ruby-rest-api
```

Then open:

- UI: `http://localhost:9000/`

## Configuration

- **`PORT`**: port to listen on (default: `9000`)
- **`BIND`**: bind address (default: `0.0.0.0`)

Example:

```bash
PORT=8080 bundle exec ruby app.rb
```

