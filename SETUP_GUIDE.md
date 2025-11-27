# QuickChat - Complete Docker & Jenkins Setup Guide

## 📋 Prerequisites
Your system already has:
- ✅ Git
- ✅ Docker Desktop for Windows
- ✅ Flutter SDK

---

## 🐳 Part 1: Docker Setup

### 1.1 Test Docker Installation
Open PowerShell and verify Docker is running:
```powershell
docker --version
docker-compose --version
docker ps
```

If Docker Desktop is not running, start it from the Start menu.

### 1.2 Build Docker Image
Navigate to your project directory:
```powershell
cd C:\Users\aaron\Downloads\MessengerApp\quickchat
```

Build the Docker image:
```powershell
docker build -t quickchat:latest .
```

This will:
- Use a multi-stage build (Flutter build + nginx)
- Build your Flutter web app
- Package it in a lightweight nginx container
- Build time: ~10-15 minutes on first run

### 1.3 Run Container
Run the container:
```powershell
docker run -d --name quickchat-app -p 3000:80 --restart unless-stopped quickchat:latest
```

Or use Docker Compose (recommended):
```powershell
docker-compose up -d
```

### 1.4 Verify Deployment
Check running containers:
```powershell
docker ps
```

Access your app: http://localhost:3000

**Note:** Port 3000 is used to avoid conflict with Jenkins on port 8080.

View logs:
```powershell
docker logs quickchat-app
```

### 1.5 Useful Docker Commands
```powershell
# Stop container
docker stop quickchat-app

# Start container
docker start quickchat-app

# Remove container
docker rm -f quickchat-app

# Remove image
docker rmi quickchat:latest

# View container stats
docker stats quickchat-app

# Enter container shell
docker exec -it quickchat-app sh

# Rebuild and restart
docker-compose up -d --build
```

---

## 🔧 Part 2: Jenkins Installation & Setup

### 2.1 Download Jenkins
1. Download Jenkins for Windows: https://www.jenkins.io/download/
2. Choose "Windows" → Download the MSI installer
3. Or download the WAR file for manual installation

### 2.2 Install Jenkins (MSI Method)

**Step 1:** Run the MSI installer as Administrator

**Step 2:** Follow the installation wizard:
- Accept license agreement
- Choose installation directory (default: `C:\Program Files\Jenkins`)
- Select "Run as Windows Service"
- Port: 8090 (avoid conflict with your app on 8080)
- Java Home: Auto-detected

**Step 3:** Complete installation and start Jenkins service

**Step 4:** Access Jenkins
Open browser: http://localhost:8090

### 2.3 Initial Jenkins Configuration

**Step 1: Unlock Jenkins**
```powershell
# Get the initial admin password
Get-Content "C:\Program Files\Jenkins\secrets\initialAdminPassword"
```
Copy the password and paste it in the browser.

**Step 2: Install Plugins**
- Choose "Install suggested plugins"
- Wait for installation to complete

**Step 3: Create Admin User**
- Username: admin
- Password: [your secure password]
- Full name: Administrator
- Email: your-email@example.com

**Step 4: Jenkins URL**
- Keep default: http://localhost:8090/

### 2.4 Configure Jenkins for Flutter & Docker

#### Install Additional Plugins

Navigate to: **Manage Jenkins** → **Manage Plugins** → **Available**

Install these plugins:
1. **Git Plugin** (usually pre-installed)
2. **Pipeline Plugin** (usually pre-installed)
3. **Docker Pipeline Plugin**
4. **Email Extension Plugin** (for build notifications)

Click "Install without restart"

#### Configure System Environment

Navigate to: **Manage Jenkins** → **System**

1. **Set Java Home** (if not auto-detected):
   - Find Java path: `where java`
   - Add in Global properties

2. **Set Git Path**:
   - Should auto-detect
   - If not, add: `C:\Program Files\Git\bin\git.exe`

3. **Email Notification** (Optional):
   - Configure SMTP server for build notifications
   - Gmail example:
     - SMTP server: `smtp.gmail.com`
     - Port: `587`
     - Use SSL: Yes
     - Credentials: Your email + app password

#### Add Flutter to PATH

Navigate to: **Manage Jenkins** → **Global Tool Configuration**

Under **Environment Variables**:
- Add `FLUTTER_HOME`: Your Flutter SDK path (e.g., `C:\Users\aaron\flutter\flutter`)
- The Jenkinsfile already adds this to PATH

**Important:** Find your Flutter path first:
```powershell
where.exe flutter
# Example output: C:\Users\aaron\flutter\flutter\bin\flutter.bat
# Use: C:\Users\aaron\flutter\flutter as FLUTTER_HOME
```

Or set system-wide:
```powershell
# Run as Administrator
[System.Environment]::SetEnvironmentVariable("FLUTTER_HOME", "C:\Users\aaron\flutter\flutter", "Machine")
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Users\aaron\flutter\flutter\bin", "Machine")
```

### 2.5 Create Jenkins Pipeline Job

**Step 1:** From Jenkins Dashboard, click "New Item"

**Step 2:** Configure the job:
- Name: `QuickChat-Pipeline`
- Type: Select "Pipeline"
- Click "OK"

**Step 3:** Configure Pipeline:

In **General** section:
- ☑ GitHub project (if using GitHub)
- Project url: `https://github.com/aaronnn1007/QuickChat/`

In **Build Triggers** section (choose one or more):
- ☑ **Poll SCM**: `H/5 * * * *` (check every 5 minutes)
- ☑ **GitHub hook trigger** (for push notifications)

In **Pipeline** section:
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/aaronnn1007/QuickChat.git`
- Branch: `*/main`
- Script Path: `Jenkinsfile`

**Step 4:** Save

### 2.6 Configure GitHub Webhook (Optional)

For automatic builds on git push:

**In GitHub:**
1. Go to your repository → Settings → Webhooks
2. Click "Add webhook"
3. Payload URL: `http://YOUR_IP:8090/github-webhook/`
4. Content type: `application/json`
5. Events: "Just the push event"
6. Active: ☑

**Note:** For local Jenkins, you may need ngrok or expose your machine.

### 2.7 Run Your First Build

**Step 1:** Go to your pipeline job

**Step 2:** Click "Build Now"

**Step 3:** Monitor the build:
- Click on build number (e.g., #1)
- Click "Console Output" to see logs

**Step 4:** Build stages:
1. ✅ Checkout - Gets code from Git
2. ✅ Flutter Doctor - Verifies Flutter setup
3. ✅ Get Dependencies - Downloads packages
4. ✅ Analyze - Runs static analysis
5. ✅ Run Tests - Executes tests
6. ✅ Build Flutter Web - Compiles web app
7. ✅ Build Docker Image - Creates Docker image
8. ✅ Stop Previous Container - Cleanup
9. ✅ Deploy - Runs new container
10. ✅ Verify Deployment - Checks status

### 2.8 Troubleshooting Jenkins

#### Flutter not found
```powershell
# Find your Flutter installation path
where.exe flutter
# Update FLUTTER_HOME in Jenkinsfile to match your Flutter path
# Example: FLUTTER_HOME = 'C:\\Users\\aaron\\flutter\\flutter'
```

#### Docker permission denied
```powershell
# Add Jenkins user to docker-users group
net localgroup docker-users "NT AUTHORITY\LOCAL SERVICE" /add

# Restart Jenkins service
Restart-Service Jenkins
```

#### Port already in use
```powershell
# If port 3000 is in use, change it in docker-compose.yml
# Check what's using the port:
netstat -ano | findstr :3000

# Or use a different port like 3001
# Update both docker-compose.yml and Jenkinsfile
```

#### Build fails on Git checkout
- Verify Git is installed and in PATH
- Check repository URL is correct
- Add Git credentials if private repo:
  - Manage Jenkins → Manage Credentials → Add

---

## 🚀 Part 3: Complete Workflow

### 3.1 Development Workflow

1. **Make code changes** in your IDE
2. **Commit and push** to GitHub:
   ```powershell
   git add .
   git commit -m "Your changes"
   git push origin main
   ```
3. **Jenkins automatically**:
   - Detects the push (if webhook configured)
   - Runs all tests
   - Builds Flutter web app
   - Creates Docker image
   - Deploys to container
4. **Access your app** at http://localhost:3000

### 3.2 Manual Docker Deployment (Without Jenkins)

If you want to deploy manually:

```powershell
# Build and deploy
docker-compose up -d --build

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

### 3.3 Production Deployment Checklist

- [ ] Update `pubspec.yaml` version
- [ ] Run tests locally: `flutter test`
- [ ] Build locally: `flutter build web --release`
- [ ] Test Docker image locally
- [ ] Update environment variables in Jenkinsfile
- [ ] Configure production server URL
- [ ] Set up SSL certificates for HTTPS
- [ ] Configure production Docker registry (DockerHub, AWS ECR, etc.)
- [ ] Update nginx.conf with production domain
- [ ] Set up monitoring and logging

---

## 📊 Part 4: Monitoring & Maintenance

### 4.1 Jenkins Monitoring

**Check Build History:**
- Dashboard shows all builds with status
- Green = Success, Red = Failure

**Email Notifications:**
- Configured in Jenkinsfile
- Sends email on success/failure
- Update recipient in: Manage Jenkins → Configure System → Extended E-mail

**Jenkins System Logs:**
```powershell
# View Jenkins logs
Get-Content "C:\Program Files\Jenkins\jenkins.log" -Tail 50 -Wait
```

### 4.2 Docker Monitoring

**Container Health:**
```powershell
# Check container status
docker ps -a

# View resource usage
docker stats quickchat-app

# Check logs
docker logs quickchat-app --tail 100 -f

# Inspect container
docker inspect quickchat-app
```

**Cleanup:**
```powershell
# Remove unused images
docker image prune -a

# Remove stopped containers
docker container prune

# Complete cleanup
docker system prune -a --volumes
```

---

## 🔒 Part 5: Security Best Practices

1. **Jenkins Security:**
   - Change default admin password
   - Enable CSRF protection
   - Configure role-based access
   - Keep Jenkins and plugins updated

2. **Docker Security:**
   - Don't run containers as root
   - Use official base images
   - Scan images for vulnerabilities: `docker scan quickchat:latest`
   - Keep Docker updated

3. **Environment Variables:**
   - Never commit secrets to Git
   - Use Jenkins credentials store
   - Use Docker secrets for sensitive data

4. **Network Security:**
   - Use firewall rules
   - Enable HTTPS with SSL/TLS
   - Restrict Docker daemon access

---

## 📚 Additional Resources

### Documentation
- **Flutter**: https://flutter.dev/docs
- **Docker**: https://docs.docker.com
- **Jenkins**: https://www.jenkins.io/doc
- **Nginx**: https://nginx.org/en/docs

### Useful Commands Reference

```powershell
# Flutter
flutter doctor -v
flutter pub get
flutter pub upgrade
flutter build web --release
flutter test
flutter analyze

# Docker
docker build -t quickchat .
docker run -d -p 8080:80 quickchat
docker ps
docker logs [container-id]
docker stop [container-id]
docker rm [container-id]
docker-compose up -d
docker-compose down

# Git
git status
git add .
git commit -m "message"
git push origin main
git pull origin main

# Jenkins (PowerShell)
Restart-Service Jenkins
Stop-Service Jenkins
Start-Service Jenkins
Get-Service Jenkins
```

---

## 🎯 Quick Start Commands

### First Time Setup
```powershell
# 1. Navigate to project
cd C:\Users\aaron\Downloads\MessengerApp\quickchat

# 2. Build Docker image
docker build -t quickchat:latest .

# 3. Run container
docker-compose up -d

# 4. Verify
docker ps
# Access: http://localhost:3000
```

### After Code Changes
```powershell
# If using Jenkins - just push to Git
git add .
git commit -m "Update features"
git push origin main
# Jenkins will auto-deploy

# If manual deployment
docker-compose up -d --build
```

---

## ❓ Common Issues & Solutions

### Issue: Flutter build fails in Docker
**Solution:** Ensure `pubspec.yaml` and `pubspec.lock` are committed to Git

### Issue: Container exits immediately
**Solution:** 
```powershell
docker logs quickchat-app
# Check logs for errors
```

### Issue: Port 3000 already in use
**Solution:**
```powershell
# Change port in docker-compose.yml
ports:
  - "3001:80"  # Use 3001 instead
# Also update the port in Jenkinsfile Deploy stage
```

### Issue: Jenkins can't find Flutter
**Solution:** Update `FLUTTER_HOME` in Jenkinsfile to your Flutter path

### Issue: Docker build is slow
**Solution:** 
- Ensure `.dockerignore` is configured
- Use Docker BuildKit: `$env:DOCKER_BUILDKIT=1`
- Check Docker Desktop resources (Settings → Resources)

---

## 🎉 Success Checklist

After completing this guide, you should have:

- ✅ Dockerized Flutter web application
- ✅ Jenkins installed and configured
- ✅ Automated CI/CD pipeline
- ✅ Application running at http://localhost:3000
- ✅ Jenkins dashboard at http://localhost:8090 (or 8080)
- ✅ Automatic builds on git push
- ✅ Containerized deployment
- ✅ Monitoring and logging setup

**Congratulations! Your QuickChat app is now fully dockerized with CI/CD automation! 🚀**

---

## 📞 Need Help?

- Check Jenkins console output for build errors
- Review Docker logs: `docker logs quickchat-app`
- Verify Flutter setup: `flutter doctor`
- Test Docker: `docker ps` and `docker version`

For more help, refer to the documentation links provided above.
