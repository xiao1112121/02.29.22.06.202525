import { useRef, useState, useEffect, useCallback } from 'react'

export function VirtualList({ items, height, itemHeight, renderItem, buffer = 5 }) {
  const [scrollTop, setScrollTop] = useState(0)
  const scrollElementRef = useRef(null)

  const startIndex = Math.max(0, Math.floor(scrollTop / itemHeight) - buffer)
  const endIndex = Math.min(
    items.length,
    Math.ceil((scrollTop + height) / itemHeight) + buffer
  )

  const visibleItems = items.slice(startIndex, endIndex)
  const totalHeight = items.length * itemHeight
  const offsetY = startIndex * itemHeight

  const handleScroll = useCallback(() => {
    if (scrollElementRef.current) {
      setScrollTop(scrollElementRef.current.scrollTop)
    }
  }, [])

  useEffect(() => {
    const scrollElement = scrollElementRef.current
    if (scrollElement) {
      scrollElement.addEventListener('scroll', handleScroll, { passive: true })
      return () => scrollElement.removeEventListener('scroll', handleScroll)
    }
  }, [handleScroll])

  return (
    <div
      ref={scrollElementRef}
      className="overflow-auto"
      style={{ height }}
    >
      <div style={{ height: totalHeight, position: 'relative' }}>
        <div
          style={{
            transform: `translateY(${offsetY}px)`,
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
          }}
        >
          {visibleItems.map((item, index) => (
            <div key={item.id} style={{ height: itemHeight }}>
              {renderItem(item, startIndex + index)}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}