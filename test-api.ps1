# Test the therapists endpoint
Write-Output "Testing therapists endpoint..."
$therapists = Invoke-WebRequest -Uri 'http://localhost:3000/api/therapists' -Method GET -UseBasicParsing
Write-Output "Therapists response: $($therapists.Content)"

# Test server health
Write-Output "`nTesting server health..."
try {
    $health = Invoke-WebRequest -Uri 'http://localhost:3000/api/therapists' -Method GET -UseBasicParsing
    Write-Output "✅ Backend server is running and responding on port 3000"
} catch {
    Write-Output "❌ Backend server error: $($_.Exception.Message)"
}

# Test Flutter app
Write-Output "`nTesting Flutter app..."
try {
    $flutter = Invoke-WebRequest -Uri 'http://localhost:8080' -Method GET -UseBasicParsing
    Write-Output "✅ Flutter app is running and accessible on port 8080"
} catch {
    Write-Output "❌ Flutter app error: $($_.Exception.Message)"
}
