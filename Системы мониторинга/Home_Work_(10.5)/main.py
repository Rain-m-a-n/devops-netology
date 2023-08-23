import sentry_sdk

sentry_sdk.init(
    dsn = "https://92cb8a5bf172fd46cbab04306926e6ca@o4505755728412672.ingest.sentry.io/4505755737456640",
    environment = "development",
    release = "1.0",
    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    # traces_sample_rate=1.0
)

if __name__ == "__main__":
    divizion_zero = 1 / 0