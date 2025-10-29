# ==========================================
#  DEVOPS FLASK APP DEMO SCRIPT (FINAL)
#  Author : Steven Thomas
#  Tools  : Docker, Kubernetes (Minikube), Ansible, Terraform, GitHub Actions
# ==========================================

Write-Host "🚀 STEP 1: Starting Docker Desktop (make sure it's already open)..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

# ------------------------------------------------------------
Write-Host "`n✅ STEP 2: Verify Docker is running" -ForegroundColor Green
docker version

# ------------------------------------------------------------
Write-Host "`n✅ STEP 3: Activate virtual environment & test Flask app locally" -ForegroundColor Green
if (-Not (Test-Path ".\.venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv .venv
}
& .\.venv\Scripts\Activate.ps1

pip install -r app/requirements.txt
Write-Host "Running Flask app locally..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "python app\app.py"
Start-Sleep -Seconds 5
Write-Host "👉 Open http://127.0.0.1:5000 to test the app locally" -ForegroundColor Cyan

# ------------------------------------------------------------
Write-Host "`n✅ STEP 4: Build and run Flask app inside Docker container" -ForegroundColor Green
docker build -t flaskapp:v1 .
docker images
docker run -d -p 5000:5000 --name flask-container flaskapp:v1
Write-Host "Flask app running inside Docker → http://localhost:5000" -ForegroundColor Cyan
Start-Sleep -Seconds 5

# ------------------------------------------------------------
Write-Host "`n✅ STEP 5: Tag and push Docker image to Docker Hub" -ForegroundColor Green
docker tag flaskapp:v1 steven0707/flaskapp:v1
docker push steven0707/flaskapp:v1

# ------------------------------------------------------------
Write-Host "`n✅ STEP 6: Start Minikube cluster (local Kubernetes)" -ForegroundColor Green
minikube start --driver=docker
kubectl get nodes

# ------------------------------------------------------------
Write-Host "`n✅ STEP 7: Deploy Flask app to Kubernetes" -ForegroundColor Green
kubectl apply -f k8s-manifests/
kubectl get pods
kubectl get svc

# ------------------------------------------------------------
Write-Host "`n✅ STEP 8: Open the Flask app in browser (via Minikube service)" -ForegroundColor Green
minikube service flask-service

# ------------------------------------------------------------
Write-Host "`n✅ STEP 9: Optional – View deployment details" -ForegroundColor Green
kubectl describe deployment flask-deployment
Write-Host "`n✅ Optional – View pod logs" -ForegroundColor Green
kubectl logs (kubectl get pods -o name | Select-String "flask" | ForEach-Object { $_ -replace 'pod/', '' })

# ------------------------------------------------------------
Write-Host "`n🎯 DEMO COMPLETE! Your DevOps Flask app is live on Kubernetes!" -ForegroundColor Cyan
Write-Host "👉 Summary:" -ForegroundColor Yellow
Write-Host "  1. Flask app containerized using Docker"
Write-Host "  2. Image pushed to Docker Hub"
Write-Host "  3. Deployed via Kubernetes (Minikube)"
Write-Host "  4. Accessed through LoadBalancer service"
