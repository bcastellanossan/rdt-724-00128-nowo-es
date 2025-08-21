import traceback

try:
    from hocelot.api.data_app import DataApp
except Exception:
    print(traceback.format_exc())

if __name__ == "__main__":
    try:
        # Create and run the data application in one simple step
        # Host, port, and product type are now configured in YAML files and environment variables
        app = DataApp()

        # Basic usage (recommended):
        app.run()  # Uses configuration from YAML with environment overrides

        # Advanced usage examples (optional kwargs for uvicorn):
        # app.run(reload=True)  # Enable auto-reload for development
        # app.run(workers=4)    # Multiple workers for production
        # app.run(access_log=False)  # Disable access logs
    except Exception:
        print(traceback.format_exc())