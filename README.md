# Personal Expense Tracker DevOps Project

This project demonstrates a complete DevOps pipeline for deploying a **Personal Expense Tracker** web application built with Flask. It covers containerization, orchestration, infrastructure as code, configuration management, and CI/CD practices.

## Project Overview

The application is a **Personal Expense Tracker** that allows users to:
- Add expenses with amount, category, date, and description
- View a list of all expenses
- See total spending and a pie chart breakdown by category

The DevOps pipeline includes:
- **Application Code**: Python Flask app with SQLite database and Bootstrap UI
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Minikube for local deployment)
- **Infrastructure as Code**: Terraform (Azure resources)
- **Configuration Management**: Ansible
- **CI/CD**: GitHub Actions

## Project Structure

```
devops-flask-app/
├── app/                          # Flask application code
│   ├── app.py                    # Main Flask application with expense tracking
│   ├── requirements.txt          # Python dependencies
│   ├── instance/
│   │   └── expenses.db           # SQLite database
│   └── templates/
│       └── index.html            # HTML template with Bootstrap and Chart.js
├── k8s-manifests/                # Kubernetes manifests
│   ├── deployment.yaml           # Deployment configuration
│   └── service.yaml              # Service configuration
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # Azure resources (RG, AKS, ACR)
│   ├── variables.tf              # Input variables
│   └── outputs.tf                # Output values (empty)
├── ansible/                      # Configuration management
│   └── deploy.yml                # Ansible playbook for deployment
├── .github/workflows/            # CI/CD pipelines
│   └── deploy.yml                # GitHub Actions workflow
├── Dockerfile                    # Docker image build instructions
├── README.md                     # This file
└── TODO.md                       # Project checklist
```

## Components Explained

### 1. Flask Application (`app/`)

- **app.py**: A Flask app with SQLAlchemy for expense tracking, WTForms for form handling, and a `/welcome` API endpoint with logging
- **requirements.txt**: Lists Flask, SQLAlchemy, WTForms, and other dependencies
- **templates/index.html**: Bootstrap-based UI with expense form, list, total spending, and Chart.js pie chart
- **instance/expenses.db**: SQLite database for storing expenses

### 2. Containerization (`Dockerfile`)

- Builds a Docker image based on Python 3.10
- Copies the app code and installs dependencies
- Exposes port 5000 and runs the Flask app

### 3. Kubernetes Orchestration (`k8s-manifests/`)

- **deployment.yaml**: Defines a deployment with 2 replicas using the Docker Hub image `steven0707/flaskapp:latest`
- **service.yaml**: Exposes the app via a LoadBalancer service on port 80, targeting port 5000

### 4. Infrastructure as Code (`terraform/`)

- **main.tf**: Provisions Azure resources:
  - Resource Group in East US
  - AKS cluster with 1 node (Standard_B2s VM)
  - Azure Container Registry (ACR) with admin enabled
- **variables.tf**: Empty (can be used for parameterization)
- **outputs.tf**: Empty (can be used to output resource details)

### 5. Configuration Management (`ansible/`)

- **deploy.yml**: Ansible playbook that:
  - Applies Kubernetes manifests
  - Waits for deployment readiness
  - Displays the service NodePort

### 6. CI/CD Pipeline (`.github/workflows/`)

- **deploy.yml**: GitHub Actions workflow that:
  - Builds and pushes Docker image to Docker Hub
  - Starts Minikube
  - Deploys to Kubernetes
  - Verifies the deployment

## Local Deployment Steps

1. **Prerequisites**:
   - Docker installed
   - Minikube installed
   - kubectl installed
   - Chocolatey (for package management on Windows)

2. **Build and Run Locally**:
   ```bash
   # Build Docker image
   docker build -t flaskapp .

   # Run locally
   docker run -p 5000:5000 flaskapp
   # Access at http://localhost:5000
   ```

3. **Deploy to Minikube**:
   ```bash
   # Start Minikube
   minikube start

   # Apply manifests
   kubectl apply -f k8s-manifests/

   # Port forward
   kubectl port-forward svc/flask-service 8081:80
   # Access at http://localhost:8081
   ```

4. **Using Ansible**:
   ```bash
   # Install Ansible via Chocolatey
   choco install ansible

   # Run playbook
   ansible-playbook ansible/deploy.yml
   ```

5. **CI/CD with GitHub Actions**:
   - Push to repository triggers the workflow
   - Builds image, pushes to Docker Hub, deploys to Minikube

## Cloud Deployment (Azure)

Note: Requires Azure subscription.

1. **Terraform**:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

2. **Update Image for ACR**:
   - Build and push to ACR
   - Update `k8s-manifests/deployment.yaml` with ACR image URL

3. **Deploy to AKS**:
   - Configure kubectl for AKS
   - Apply manifests

## Verification

- **Pods**: `kubectl get pods` (should show 2 running pods)
- **Service**: `kubectl get svc` (LoadBalancer with external IP or NodePort)
- **Access**: Use port-forwarding or external IP to access the app
- **Response**: Personal Expense Tracker with form to add expenses, list of expenses, total spending, and category pie chart

## Technologies Used

- **Python/Flask**: Web framework with SQLAlchemy ORM
- **SQLite**: Database for expense storage
- **Bootstrap**: CSS framework for responsive UI
- **Chart.js**: JavaScript library for data visualization
- **Docker**: Containerization
- **Kubernetes/Minikube**: Orchestration
- **Terraform**: IaC
- **Ansible**: Configuration management
- **GitHub Actions**: CI/CD
- **Azure**: Cloud provider (RG, AKS, ACR)

## Key DevOps Practices Demonstrated

- Containerization for portability
- Orchestration for scalability
- IaC for reproducible infrastructure
- Configuration management for automation
- CI/CD for automated deployments
- Version control and collaboration
- Database integration in containerized apps
- API endpoints with logging
- Web UI with charts and forms

## Screenshots

### Application UI
![Expense Tracker UI](https://via.placeholder.com/800x400?text=Personal+Expense+Tracker+UI)

### Kubernetes Pods
```bash
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
flask-deployment-6b9f7c8d4-abc12   2/2     Running   0          5m
flask-deployment-6b9f7c8d4-def34   2/2     Running   0          5m
```

### CI/CD Pipeline
![GitHub Actions](https://via.placeholder.com/800x200?text=GitHub+Actions+CI/CD+Pipeline)

