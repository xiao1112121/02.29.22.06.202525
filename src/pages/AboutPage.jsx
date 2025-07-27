import { useState, useEffect } from 'react'
import { reportWebVitals } from '../utils/reportWebVitals'

function AboutPage() {
  const [vitals, setVitals] = useState({})

  useEffect(() => {
    // Collect web vitals
    reportWebVitals((metric) => {
      setVitals((prev) => ({
        ...prev,
        [metric.name]: metric.value,
      }))
    })
  }, [])

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-sm p-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-4">About This App</h1>
        <p className="text-gray-600 mb-6">
          This is a performance-optimized React application demonstrating modern web development
          best practices for optimal loading times and user experience.
        </p>

        <h2 className="text-2xl font-semibold text-gray-900 mb-4">Performance Features</h2>
        <ul className="space-y-2 text-gray-600">
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Code splitting with React.lazy() for smaller initial bundle</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Virtual scrolling for large lists (see Dashboard)</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Image lazy loading with intersection observer</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>PWA support with service worker caching</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Optimized React Query for data fetching and caching</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Zustand for lightweight state management</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Vite for fast development and optimized builds</span>
          </li>
          <li className="flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            <span>Compression (gzip & brotli) for smaller file sizes</span>
          </li>
        </ul>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8">
        <h2 className="text-2xl font-semibold text-gray-900 mb-4">Web Vitals</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <VitalCard
            name="FCP"
            fullName="First Contentful Paint"
            value={vitals.FCP}
            unit="ms"
            good={1800}
            needsImprovement={3000}
          />
          <VitalCard
            name="LCP"
            fullName="Largest Contentful Paint"
            value={vitals.LCP}
            unit="ms"
            good={2500}
            needsImprovement={4000}
          />
          <VitalCard
            name="CLS"
            fullName="Cumulative Layout Shift"
            value={vitals.CLS}
            unit=""
            good={0.1}
            needsImprovement={0.25}
          />
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-8">
        <h2 className="text-2xl font-semibold text-gray-900 mb-4">Build Optimization</h2>
        <p className="text-gray-600 mb-4">
          Run <code className="bg-gray-100 px-2 py-1 rounded">npm run build</code> to create an
          optimized production build, then <code className="bg-gray-100 px-2 py-1 rounded">npm run analyze</code> to
          visualize the bundle size.
        </p>
      </div>
    </div>
  )
}

function VitalCard({ name, fullName, value, unit, good, needsImprovement }) {
  const getStatus = () => {
    if (!value) return 'pending'
    if (value <= good) return 'good'
    if (value <= needsImprovement) return 'needs-improvement'
    return 'poor'
  }

  const status = getStatus()
  const statusColors = {
    pending: 'bg-gray-100 text-gray-600',
    good: 'bg-green-100 text-green-800',
    'needs-improvement': 'bg-yellow-100 text-yellow-800',
    poor: 'bg-red-100 text-red-800',
  }

  return (
    <div className="border rounded-lg p-4">
      <div className="flex justify-between items-start mb-2">
        <h3 className="font-semibold text-gray-900">{name}</h3>
        <span className={`text-xs px-2 py-1 rounded ${statusColors[status]}`}>
          {status === 'pending' ? 'Measuring...' : status.replace('-', ' ')}
        </span>
      </div>
      <p className="text-sm text-gray-500 mb-2">{fullName}</p>
      <p className="text-2xl font-bold text-gray-900">
        {value ? `${value.toFixed(unit ? 0 : 2)}${unit}` : '-'}
      </p>
    </div>
  )
}

export default AboutPage