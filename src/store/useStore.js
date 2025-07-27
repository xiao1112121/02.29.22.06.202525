import { create } from 'zustand'
import { devtools } from 'zustand/middleware'

export const useStore = create(
  devtools(
    (set) => ({
      // Counter state
      counter: 0,
      incrementCounter: () => set((state) => ({ counter: state.counter + 1 })),
      decrementCounter: () => set((state) => ({ counter: state.counter - 1 })),
      resetCounter: () => set({ counter: 0 }),

      // User preferences
      theme: 'light',
      setTheme: (theme) => set({ theme }),

      // Cache for expensive computations
      computationCache: new Map(),
      setComputationCache: (key, value) =>
        set((state) => {
          const newCache = new Map(state.computationCache)
          newCache.set(key, value)
          return { computationCache: newCache }
        }),
      
      clearComputationCache: () => set({ computationCache: new Map() }),
    }),
    {
      name: 'app-store', // name for devtools
    }
  )
)