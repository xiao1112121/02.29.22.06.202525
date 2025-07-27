import { useMemo, useCallback, useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { LoadingSpinner } from '../components/LoadingSpinner'
import { VirtualList } from '../components/VirtualList'
import { useStore } from '../store/useStore'

// Simulated API call
const fetchDashboardData = async () => {
  await new Promise(resolve => setTimeout(resolve, 800))
  return {
    metrics: {
      totalUsers: 1234,
      activeUsers: 892,
      revenue: 45678,
      growth: 12.5,
    },
    items: Array.from({ length: 1000 }, (_, i) => ({
      id: i + 1,
      name: `Item ${i + 1}`,
      value: Math.floor(Math.random() * 1000),
      status: ['active', 'pending', 'inactive'][Math.floor(Math.random() * 3)],
    })),
  }
}

function DashboardPage() {
  const [filter, setFilter] = useState('all')
  const { incrementCounter, counter } = useStore()

  const { data, isLoading, error } = useQuery({
    queryKey: ['dashboard-data'],
    queryFn: fetchDashboardData,
  })

  // Memoize filtered items
  const filteredItems = useMemo(() => {
    if (!data?.items) return []
    if (filter === 'all') return data.items
    return data.items.filter(item => item.status === filter)
  }, [data?.items, filter])

  const handleFilterChange = useCallback((newFilter) => {
    setFilter(newFilter)
  }, [])

  if (isLoading) return <LoadingSpinner size="lg" />
  if (error) return <div className="text-red-600">Error loading dashboard data</div>

  return (
    <div className="space-y-6">
      {/* Metrics Grid */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <MetricCard title="Total Users" value={data.metrics.totalUsers} />
        <MetricCard title="Active Users" value={data.metrics.activeUsers} />
        <MetricCard title="Revenue" value={`$${data.metrics.revenue.toLocaleString()}`} />
        <MetricCard title="Growth" value={`${data.metrics.growth}%`} trend="up" />
      </div>

      {/* Global State Example */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-xl font-semibold mb-4">Global State Management</h2>
        <p className="text-gray-600 mb-4">Counter: {counter}</p>
        <button
          onClick={incrementCounter}
          className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 transition-colors"
        >
          Increment Counter
        </button>
      </div>

      {/* Filter Controls */}
      <div className="bg-white rounded-lg shadow-sm p-4">
        <div className="flex gap-2">
          {['all', 'active', 'pending', 'inactive'].map((status) => (
            <button
              key={status}
              onClick={() => handleFilterChange(status)}
              className={`px-4 py-2 rounded transition-colors ${
                filter === status
                  ? 'bg-blue-500 text-white'
                  : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
              }`}
            >
              {status.charAt(0).toUpperCase() + status.slice(1)}
            </button>
          ))}
        </div>
      </div>

      {/* Virtualized List */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <h2 className="text-xl font-semibold mb-4">
          Items List ({filteredItems.length} items)
        </h2>
        <VirtualList
          items={filteredItems}
          height={400}
          itemHeight={60}
          renderItem={(item) => (
            <div className="flex items-center justify-between p-3 border-b border-gray-100">
              <div>
                <h3 className="font-medium">{item.name}</h3>
                <span className={`text-sm ${
                  item.status === 'active' ? 'text-green-600' :
                  item.status === 'pending' ? 'text-yellow-600' :
                  'text-gray-500'
                }`}>
                  {item.status}
                </span>
              </div>
              <div className="text-lg font-semibold">{item.value}</div>
            </div>
          )}
        />
      </div>
    </div>
  )
}

function MetricCard({ title, value, trend }) {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <h3 className="text-sm font-medium text-gray-500">{title}</h3>
      <div className="mt-2 flex items-baseline">
        <p className="text-2xl font-semibold text-gray-900">{value}</p>
        {trend && (
          <span className={`ml-2 text-sm ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
            {trend === 'up' ? '↑' : '↓'}
          </span>
        )}
      </div>
    </div>
  )
}

export default DashboardPage