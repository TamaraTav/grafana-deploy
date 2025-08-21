# Grafana Deploy Project

## Load Testing (დატვირთვის ტესტირება)

### Apache Bench-ით (Linux/Mac):

```bash
ab -k -c 5 -n 20000 'http://localhost:8080/' & \
ab -k -c 5 -n 2000 'http://localhost:8080/status/400' & \
ab -k -c 5 -n 3000 'http://localhost:8080/status/409' & \
ab -k -c 5 -n 5000 'http://localhost:8080/status/500' & \
ab -k -c 50 -n 5000 'http://localhost:8080/status/200?seconds_sleep=1' & \
ab -k -c 50 -n 2000 'http://localhost:8080/status/200?seconds_sleep=2'
```

### PowerShell-ით (Windows):

Windows-ზე Apache Bench-ის ნაცვლად შეგიძლიათ PowerShell script-ის გამოყენება:

```powershell
# Load testing script-ის გაშვება
.\load-test.ps1
```

**ტესტები რომლებიც ხორციელდება:**

- **Test 1**: Root endpoint (20,000 requests)
- **Test 2**: Status 400 (2,000 requests)
- **Test 3**: Status 409 (3,000 requests)
- **Test 4**: Status 500 (5,000 requests)
- **Test 5**: Status 200 with 1s sleep (5,000 requests)
- **Test 6**: Status 200 with 2s sleep (2,000 requests)

## პროექტის გაშვება:

```bash
# ყველა სერვისის გაშვება
docker-compose up -d

# სერვისების შეჩერება
docker-compose down
```

## მონიტორინგი:

- **Backend API**: http://localhost:8080
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090
- **Loki**: http://localhost:3100
- **API Documentation**: http://localhost:8080/docs

## მონიტორინგის დაფები:

Grafana-ში შეგიძლიათ იხილოთ:

- **Total Requests**: მოთხოვნების რაოდენობა ენდპოინტების მიხედვით
- **Requests Average Duration**: მოთხოვნების საშუალო ხანგრძლივობა
- **Request Per Sec**: მოთხოვნების რაოდენობა წამში
- **Request In Process**: დამუშავების პროცესში მყოფი მოთხოვნები
- **Logs**: API-ის ლოგები real-time-ში

## Dashboard-ის იმპორტი:

Grafana-ში შედით admin/admin-ით და იმპორტი გაუკეთეთ `/grafana/example-dashboard.json` ფაილს.

## Load Testing Results:

Load testing-ის შედეგები real-time-ში გამოჩნდება Grafana-ში, სადაც შეგიძლიათ ნახოთ:

- API-ის performance მეტრიკები
- მოთხოვნების დამუშავების სიჩქარე
- error rate-ები
- response time-ები
