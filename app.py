from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "POC of Deploying simple python application on ECS Completed successfully. Also Infra of ECS is created using Terraform."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
