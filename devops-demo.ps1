# ==========================================
#  DEVOPS FLASK APP DEMO SCRIPT
#  Author : Steven Thomas
#  Tools  : Docker, Kubernetes (Minikube), Ansible, Terraform, GitHub Actions
# ==========================================

Write-Host "🚀 STEP 1: Starting Docker Desktop (make sure it's already open)..."
Start-Sleep -Seconds 5

# ------------------------------------------------------------
Write-Host "`n✅ STEP 2: Verify Docker is running"
docker version

# ------------------------------------------------------------
Write-Host "`n✅ STEP 3: Run Flask app inside Docker container"
cd "C:\Users\Steven S\Desktop\devops-flask-app"
docker build -t flaskapp:v1 .
docker images
docker run -d -p 5000:5000 --name flask-container flaskapp:v1
Write-Host "Flask app running inside Docker → http://localhost:5000"
Start-Sleep -Seconds 5

# ------------------------------------------------------------
Write-Host "`n✅ STEP 4: Tag and push image to Docker Hub"
docker tag flaskapp:v1 steven0707/flaskapp:v1
docker push steven0707/flaskapp:v1

# ------------------------------------------------------------
Write-Host "`n✅ STEP 5: Start Minikube cluster (local Kubernetes)"
minikube start --driver=docker
kubectl get nodes

# ------------------------------------------------------------
Write-Host "`n✅ STEP 6: Deploy Flask app to Kubernetes"
kubectl apply -f k8s-manifests/
kubectl get pods
kubectl get svc

# ------------------------------------------------------------
Write-Host "`n✅ STEP 7: Open the Flask app in browser (via Minikube service)"
minikube service flask-service

# ------------------------------------------------------------
Write-Host "`n✅ STEP 8: Optional – view deployment details"
kubectl describe deployment flask-deployment
Write-Host "`n✅ Optional – view pod logs"
kubectl logs (kubectl get pods -o name | Select-String "flask" | ForEach-Object { $_ -replace 'pod/', '' })

# ------------------------------------------------------------
Write-Host "`n🎯 DEMO COMPLETE! Your DevOps Flask app is live on Kubernetes!"
Write-Host "👉 Summary:"
Write-Host "  1. Flask app containerized using Docker"
Write-Host "  2. Image pushed to Docker Hub"
Write-Host "  3. Deployed via Kubernetes (Minikube)"
Write-Host "  4. Accessed through LoadBalancer service"
