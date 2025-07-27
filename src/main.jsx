import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './styles/index.css'

// Enable React concurrent features for better performance
ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)

// Register service worker for PWA
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js').catch(() => {
      // Service worker registration failed, app will still work normally
    })
  })
}

// Report web vitals for performance monitoring
if (import.meta.env.PROD) {
  import('./utils/reportWebVitals.js').then(({ reportWebVitals }) => {
    reportWebVitals(console.log)
  })
}