const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    service: 'mehmat-microservice'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Mehmat Microservice',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      api: '/api/message'
    }
  });
});

// Sample API endpoint
app.get('/api/message', (req, res) => {
  res.json({
    message: 'Hello from Mehmat Microservice running on AKS!',
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`Mehmat Microservice is running on port ${PORT}`);
});
