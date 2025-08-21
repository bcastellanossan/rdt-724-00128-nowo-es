import requests
import yaml

response = requests.get("http://0.0.0.0:8083/openapi.json").json()
openapi_yaml = yaml.dump(response, sort_keys=False)

with open("./resources/rdt_swagger.yaml", "w") as f:
    f.write(openapi_yaml)
