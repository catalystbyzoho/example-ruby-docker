FROM ruby:3.3-alpine AS builder

WORKDIR /app

# Build dependencies for native gems (puma)
RUN apk add --no-cache build-base linux-headers

COPY Gemfile ./
RUN bundle install --jobs 4 --retry 3

COPY . .


FROM ruby:3.3-alpine

WORKDIR /app

RUN addgroup -S app && adduser -S app -G app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

ENV RACK_ENV=production
ENV BIND=0.0.0.0
ENV PORT=4567

USER app

EXPOSE 4567

CMD ["bundle", "exec", "ruby", "app.rb"]

