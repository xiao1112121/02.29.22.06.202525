import { lazy, Suspense } from 'react'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ErrorBoundary } from './components/ErrorBoundary'
import { LoadingSpinner } from './components/LoadingSpinner'
import { Layout } from './components/Layout'

// Lazy load pages for code splitting
const HomePage = lazy(() => import('./pages/HomePage'))
const AboutPage = lazy(() => import('./pages/AboutPage'))
const DashboardPage = lazy(() => import('./pages/DashboardPage'))
const NotFoundPage = lazy(() => import('./pages/NotFoundPage'))

// Configure React Query for optimal performance
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      cacheTime: 10 * 60 * 1000, // 10 minutes
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
})

function App() {
  return (
    <ErrorBoundary>
      <QueryClientProvider client={queryClient}>
        <Router>
          <Layout>
            <Suspense fallback={<LoadingSpinner />}>
              <Routes>
                <Route path="/" element={<HomePage />} />
                <Route path="/about" element={<AboutPage />} />
                <Route path="/dashboard" element={<DashboardPage />} />
                <Route path="*" element={<NotFoundPage />} />
              </Routes>
            </Suspense>
          </Layout>
        </Router>
      </QueryClientProvider>
    </ErrorBoundary>
  )
}

export default App