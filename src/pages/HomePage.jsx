import { useCallback, useMemo } from 'react'
import { useQuery } from '@tanstack/react-query'
import { LoadingSpinner } from '../components/LoadingSpinner'
import { useIntersectionObserver } from '../hooks/useIntersectionObserver'
import { LazyImage } from '../components/LazyImage'

// Simulated API call
const fetchHomeData = async () => {
  await new Promise(resolve => setTimeout(resolve, 500))
  return {
    hero: {
      title: 'Performance Optimized App',
      subtitle: 'Built with modern web performance best practices',
    },
    features: [
      { id: 1, title: 'Fast Load Times', description: 'Optimized bundle size and code splitting' },
      { id: 2, title: 'Lazy Loading', description: 'Images and components load on demand' },
      { id: 3, title: 'PWA Ready', description: 'Works offline with service worker caching' },
      { id: 4, title: 'Modern Stack', description: 'React 18, Vite, and performance-focused tools' },
    ],
  }
}

function HomePage() {
  // Use React Query for data fetching with caching
  const { data, isLoading, error } = useQuery({
    queryKey: ['home-data'],
    queryFn: fetchHomeData,
  })

  // Memoize computed values
  const sortedFeatures = useMemo(() => {
    return data?.features || []
  }, [data?.features])

  if (isLoading) return <LoadingSpinner size="lg" />
  if (error) return <div className="text-red-600">Error loading data</div>

  return (
    <div className="space-y-8">
      {/* Hero Section */}
      <section className="bg-white rounded-lg shadow-sm p-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">{data.hero.title}</h1>
        <p className="text-xl text-gray-600">{data.hero.subtitle}</p>
      </section>

      {/* Features Grid */}
      <section className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {sortedFeatures.map((feature) => (
          <FeatureCard key={feature.id} feature={feature} />
        ))}
      </section>

      {/* Lazy loaded image example */}
      <section className="bg-white rounded-lg shadow-sm p-8">
        <h2 className="text-2xl font-bold text-gray-900 mb-4">Optimized Images</h2>
        <LazyImage
          src="https://via.placeholder.com/800x400"
          alt="Placeholder image"
          className="w-full h-64 object-cover rounded-lg"
        />
      </section>
    </div>
  )
}

// Memoized feature card component
function FeatureCard({ feature }) {
  const { ref, isIntersecting } = useIntersectionObserver({
    threshold: 0.1,
    rootMargin: '50px',
  })

  return (
    <div
      ref={ref}
      className={`bg-white rounded-lg shadow-sm p-6 transition-opacity duration-500 ${
        isIntersecting ? 'opacity-100' : 'opacity-0'
      }`}
    >
      <h3 className="text-lg font-semibold text-gray-900 mb-2">{feature.title}</h3>
      <p className="text-gray-600">{feature.description}</p>
    </div>
  )
}

export default HomePage