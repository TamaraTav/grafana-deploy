# Load Testing Script - Apache Bench-ის ალტერნატივა PowerShell-ით

Write-Host "Starting Load Tests..." -ForegroundColor Green

# Test 1: Root endpoint - 20000 requests
Write-Host "Test 1: Root endpoint (20000 requests)" -ForegroundColor Yellow
$job1 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 20000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/" -UseBasicParsing -TimeoutSec 5
            if ($i % 1000 -eq 0) { Write-Host "Root: $i requests completed" }
        } catch {
            Write-Warning "Request $i failed: $_"
        }
    }
}

# Test 2: 400 status - 2000 requests  
Write-Host "Test 2: Status 400 (2000 requests)" -ForegroundColor Yellow
$job2 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 2000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/status/400" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($i % 200 -eq 0) { Write-Host "400 Status: $i requests completed" }
        } catch {
            # Expected to fail with 400 status
        }
    }
}

# Test 3: 409 status - 3000 requests
Write-Host "Test 3: Status 409 (3000 requests)" -ForegroundColor Yellow  
$job3 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 3000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/status/409" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($i % 300 -eq 0) { Write-Host "409 Status: $i requests completed" }
        } catch {
            # Expected to fail with 409 status
        }
    }
}

# Test 4: 500 status - 5000 requests
Write-Host "Test 4: Status 500 (5000 requests)" -ForegroundColor Yellow
$job4 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 5000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/status/500" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
            if ($i % 500 -eq 0) { Write-Host "500 Status: $i requests completed" }
        } catch {
            # Expected to fail with 500 status
        }
    }
}

# Test 5: 200 with 1 second sleep - 5000 requests
Write-Host "Test 5: Status 200 with 1s sleep (5000 requests)" -ForegroundColor Yellow
$job5 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 5000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/status/200?seconds_sleep=1" -UseBasicParsing -TimeoutSec 10
            if ($i % 500 -eq 0) { Write-Host "200+1s: $i requests completed" }
        } catch {
            Write-Warning "Request $i failed: $_"
        }
    }
}

# Test 6: 200 with 2 second sleep - 2000 requests
Write-Host "Test 6: Status 200 with 2s sleep (2000 requests)" -ForegroundColor Yellow
$job6 = Start-Job -ScriptBlock {
    for ($i = 1; $i -le 2000; $i++) {
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080/status/200?seconds_sleep=2" -UseBasicParsing -TimeoutSec 15
            if ($i % 200 -eq 0) { Write-Host "200+2s: $i requests completed" }
        } catch {
            Write-Warning "Request $i failed: $_"
        }
    }
}

Write-Host "All tests started in parallel. Waiting for completion..." -ForegroundColor Cyan

# Wait for all jobs to complete
$jobs = @($job1, $job2, $job3, $job4, $job5, $job6)
$jobs | Wait-Job

Write-Host "All load tests completed!" -ForegroundColor Green

# Clean up jobs
$jobs | Remove-Job

Write-Host "Check Grafana at http://localhost:3000 (admin/admin) for metrics visualization" -ForegroundColor Magenta
